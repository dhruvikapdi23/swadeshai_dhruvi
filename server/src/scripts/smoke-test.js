/**
 * Offline smoke test — slot utils only (no Firebase required).
 * Run: node src/scripts/smoke-test.js
 */
const assert = require('assert');
const {
  buildSlotId,
  parseSlotId,
  generateSlotsForDate,
} = require('../utils/slots');

const slotId = buildSlotId('venue-1', '2026-06-10', 21);
assert.strictEqual(slotId, 'venue-1-2026-06-10-21');

const parsed = parseSlotId(slotId);
assert.deepStrictEqual(parsed, { venueId: 'venue-1', date: '2026-06-10', hour: 21 });

const slots = generateSlotsForDate('venue-1', '2026-06-10');
assert.strictEqual(slots.length, 16, 'expected 16 slots (6 AM – 10 PM)');
assert.strictEqual(slots[0].status, 'available');
assert.strictEqual(slots[slots.length - 1].id, 'venue-1-2026-06-10-21');

console.log('Smoke test passed:', slots.length, 'slots generated');
