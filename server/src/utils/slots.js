const SLOT_START_HOUR = 6;
const SLOT_END_HOUR = 22; // slots run 6:00–22:00 (last slot 21:00–22:00)

const DATE_REGEX = /^\d{4}-\d{2}-\d{2}$/;

function isValidDate(date) {
  if (!DATE_REGEX.test(date)) return false;
  const parsed = new Date(`${date}T00:00:00`);
  return !Number.isNaN(parsed.getTime());
}

/** Slot id format: venue-1-2026-06-10-14 */
function buildSlotId(venueId, date, hour) {
  return `${venueId}-${date}-${hour}`;
}

function parseSlotId(slotId) {
  const match = slotId.match(/^(.+)-(\d{4}-\d{2}-\d{2})-(\d{1,2})$/);
  if (!match) return null;

  const [, venueId, date, hourStr] = match;
  const hour = Number(hourStr);

  if (!isValidDate(date) || Number.isNaN(hour)) return null;
  if (hour < SLOT_START_HOUR || hour > SLOT_END_HOUR - 1) return null; // 6–21

  return { venueId, date, hour };
}

/** Unique lock document id for Firestore — prevents double booking. */
function buildSlotLockId(venueId, date, hour) {
  return `${venueId}_${date}_${hour}`;
}

function buildSlotTimes(date, hour) {
  const start = new Date(`${date}T${String(hour).padStart(2, '0')}:00:00`);
  const end = new Date(start.getTime() + 60 * 60 * 1000);
  return {
    slotStart: start.toISOString(),
    slotEnd: end.toISOString(),
  };
}

function generateSlotsForDate(venueId, date, bookedSlotIds = new Set()) {
  const slots = [];

  for (let hour = SLOT_START_HOUR; hour <= SLOT_END_HOUR - 1; hour += 1) {
    const id = buildSlotId(venueId, date, hour);
    const { slotStart, slotEnd } = buildSlotTimes(date, hour);

    slots.push({
      id,
      venueId,
      startTime: slotStart,
      endTime: slotEnd,
      status: bookedSlotIds.has(id) ? 'booked' : 'available',
    });
  }

  return slots;
}

module.exports = {
  SLOT_START_HOUR,
  SLOT_END_HOUR,
  DATE_REGEX,
  isValidDate,
  buildSlotId,
  parseSlotId,
  buildSlotLockId,
  buildSlotTimes,
  generateSlotsForDate,
};
