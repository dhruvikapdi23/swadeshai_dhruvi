const { getDb } = require('../config/firebase');
const { VENUES } = require('../data/venues.seed');

const VENUES_COLLECTION = 'venues';

async function seedVenuesIfEmpty() {
  const db = getDb();
  const snapshot = await db.collection(VENUES_COLLECTION).limit(1).get();

  if (!snapshot.empty) {
    console.log('Venues already exist — skipping seed.');
    return 0;
  }

  const batch = db.batch();
  for (const venue of VENUES) {
    batch.set(db.collection(VENUES_COLLECTION).doc(venue.id), venue);
  }
  await batch.commit();
  console.log(`Seeded ${VENUES.length} venues into Firestore.`);
  return VENUES.length;
}

module.exports = { seedVenuesIfEmpty };
