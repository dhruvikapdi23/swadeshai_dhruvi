const path = require('path');
const admin = require('firebase-admin');

let db = null;

function initFirebase() {
  if (admin.apps.length > 0) {
    db = admin.firestore();
    return db;
  }

  const credentialsPath = process.env.GOOGLE_APPLICATION_CREDENTIALS;
  const emulatorHost = process.env.FIRESTORE_EMULATOR_HOST;

  if (emulatorHost) {
    process.env.FIRESTORE_EMULATOR_HOST = emulatorHost;
    admin.initializeApp({ projectId: process.env.FIREBASE_PROJECT_ID || 'quickslot-demo' });
    console.log(`Firestore emulator: ${emulatorHost}`);
  } else if (credentialsPath) {
    const resolved = path.resolve(credentialsPath);
    // eslint-disable-next-line import/no-dynamic-require, global-require
    const serviceAccount = require(resolved);
    admin.initializeApp({
      credential: admin.credential.cert(serviceAccount),
      projectId: serviceAccount.project_id,
    });
    console.log(`Firebase Admin initialized — project: ${serviceAccount.project_id}`);
  } else {
    throw new Error(
      'Set GOOGLE_APPLICATION_CREDENTIALS or FIRESTORE_EMULATOR_HOST in .env',
    );
  }

  db = admin.firestore();
  return db;
}

function getDb() {
  if (!db) {
    return initFirebase();
  }
  return db;
}

module.exports = { initFirebase, getDb, admin };
