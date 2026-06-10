const { getDb } = require('../config/firebase');
const { generateSlotsForDate, isValidDate } = require('../utils/slots');

const VENUES_COLLECTION = 'venues';
const SLOT_LOCKS_COLLECTION = 'slot_locks';

async function listVenues() {
  const snapshot = await getDb().collection(VENUES_COLLECTION).get();
  return snapshot.docs.map((doc) => doc.data());
}

async function getVenueById(venueId) {
  const doc = await getDb().collection(VENUES_COLLECTION).doc(venueId).get();
  if (!doc.exists) return null;
  return doc.data();
}

async function getSlotsForDate(venueId, date) {
  if (!isValidDate(date)) {
    const error = new Error('Invalid date format. Use YYYY-MM-DD');
    error.status = 400;
    throw error;
  }

  const venue = await getVenueById(venueId);
  if (!venue) {
    const error = new Error('Venue not found');
    error.status = 404;
    throw error;
  }

  const locksSnapshot = await getDb()
    .collection(SLOT_LOCKS_COLLECTION)
    .where('venueId', '==', venueId)
    .where('date', '==', date)
    .get();

  const bookedSlotIds = new Set(
    locksSnapshot.docs.map((doc) => doc.data().slotId),
  );

  return generateSlotsForDate(venueId, date, bookedSlotIds);
}

module.exports = { listVenues, getVenueById, getSlotsForDate };
