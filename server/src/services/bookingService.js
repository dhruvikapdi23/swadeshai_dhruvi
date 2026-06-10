const { getDb } = require('../config/firebase');
const { getVenueById } = require('./venueService');
const {
  parseSlotId,
  buildSlotLockId,
  buildSlotTimes,
  isValidDate,
} = require('../utils/slots');

const BOOKINGS_COLLECTION = 'bookings';
const SLOT_LOCKS_COLLECTION = 'slot_locks';

class SlotTakenError extends Error {
  constructor() {
    super('This slot was just booked by someone else');
    this.name = 'SlotTakenError';
    this.status = 409;
  }
}

function validateBookingInput({ venueId, slotId, date }) {
  if (!venueId || !slotId || !date) {
    const error = new Error('venueId, slotId, and date are required');
    error.status = 400;
    throw error;
  }

  if (!isValidDate(date)) {
    const error = new Error('Invalid date format. Use YYYY-MM-DD');
    error.status = 400;
    throw error;
  }

  const parsed = parseSlotId(slotId);
  if (!parsed) {
    const error = new Error('Invalid slotId format');
    error.status = 400;
    throw error;
  }

  if (parsed.venueId !== venueId || parsed.date !== date) {
    const error = new Error('slotId does not match venueId and date');
    error.status = 400;
    throw error;
  }

  return parsed;
}

/**
 * Concurrency-safe booking via Firestore transaction.
 * slot_locks doc id is unique per venue+date+hour — only one writer wins.
 */
async function createBooking(userId, { venueId, slotId, date }) {
  const parsed = validateBookingInput({ venueId, slotId, date });

  const venue = await getVenueById(venueId);
  if (!venue) {
    const error = new Error('Venue not found');
    error.status = 404;
    throw error;
  }

  const db = getDb();
  const lockId = buildSlotLockId(venueId, date, parsed.hour);
  const lockRef = db.collection(SLOT_LOCKS_COLLECTION).doc(lockId);
  const bookingRef = db.collection(BOOKINGS_COLLECTION).doc();
  const { slotStart, slotEnd } = buildSlotTimes(date, parsed.hour);

  const booking = await db.runTransaction(async (transaction) => {
    const lockDoc = await transaction.get(lockRef);

    if (lockDoc.exists) {
      throw new SlotTakenError();
    }

    const bookingData = {
      id: bookingRef.id,
      userId,
      venueId,
      slotId,
      date,
      slotStart,
      slotEnd,
      venueName: venue.name,
      createdAt: new Date().toISOString(),
    };

    transaction.set(lockRef, {
      venueId,
      date,
      hour: parsed.hour,
      slotId,
      bookingId: bookingRef.id,
      userId,
      slotStart,
      slotEnd,
    });

    transaction.set(bookingRef, bookingData);

    return bookingData;
  });

  return booking;
}

async function getUserBookings(userId) {
  const snapshot = await getDb()
    .collection(BOOKINGS_COLLECTION)
    .where('userId', '==', userId)
    .get();

  const bookings = snapshot.docs.map((doc) => ({
    id: doc.id,
    ...doc.data(),
  }));
  bookings.sort((a, b) => new Date(b.slotStart) - new Date(a.slotStart));
  return bookings;
}

async function cancelBooking(userId, bookingId) {
  const db = getDb();
  const bookingRef = db.collection(BOOKINGS_COLLECTION).doc(bookingId);
  const bookingDoc = await bookingRef.get();

  if (!bookingDoc.exists) {
    const error = new Error('Booking not found');
    error.status = 404;
    throw error;
  }

  const booking = bookingDoc.data();

  if (booking.userId !== userId) {
    const error = new Error('You can only cancel your own bookings');
    error.status = 403;
    throw error;
  }

  const parsed = parseSlotId(booking.slotId);
  if (!parsed) {
    const error = new Error('Corrupt booking data');
    error.status = 500;
    throw error;
  }

  const lockId = buildSlotLockId(booking.venueId, booking.date, parsed.hour);
  const lockRef = db.collection(SLOT_LOCKS_COLLECTION).doc(lockId);

  await db.runTransaction(async (transaction) => {
    transaction.delete(bookingRef);
    transaction.delete(lockRef);
  });
}

module.exports = {
  SlotTakenError,
  createBooking,
  getUserBookings,
  cancelBooking,
};
