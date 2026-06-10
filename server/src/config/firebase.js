const fs = require('fs');
const path = require('path');
const admin = require('firebase-admin');

let db = null;

function normalizePrivateKey(serviceAccount) {
  if (!serviceAccount?.private_key || typeof serviceAccount.private_key !== 'string') {
    return serviceAccount;
  }

  let key = serviceAccount.private_key.trim();

  // Render/env dashboards often store literal "\n" instead of real newlines.
  if (key.includes('\\n')) {
    key = key.replace(/\\n/g, '\n');
  }

  serviceAccount.private_key = key;
  return serviceAccount;
}

function parseServiceAccountFromEnv(raw) {
  let json = raw.trim();

  // Strip accidental wrapping quotes from the dashboard UI.
  if (
    (json.startsWith("'") && json.endsWith("'"))
    || (json.startsWith('"') && json.endsWith('"'))
  ) {
    json = json.slice(1, -1);
  }

  const serviceAccount = JSON.parse(json);
  return normalizePrivateKey(serviceAccount);
}

function loadServiceAccountFromEnv() {
  const base64 = process.env.FIREBASE_SERVICE_ACCOUNT_BASE64;
  if (base64) {
    const json = Buffer.from(base64.trim(), 'base64').toString('utf8');
    return parseServiceAccountFromEnv(json);
  }

  const credentialsJson = process.env.FIREBASE_SERVICE_ACCOUNT;
  if (credentialsJson) {
    return parseServiceAccountFromEnv(credentialsJson);
  }

  return null;
}

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
  } else {
    const serviceAccount = loadServiceAccountFromEnv();

    if (serviceAccount) {
      admin.initializeApp({
        credential: admin.credential.cert(serviceAccount),
        projectId: serviceAccount.project_id,
      });
      console.log(`Firebase Admin initialized — project: ${serviceAccount.project_id}`);
    } else if (credentialsPath) {
      const resolved = path.resolve(credentialsPath);
      const raw = fs.readFileSync(resolved, 'utf8');
      const fromFile = normalizePrivateKey(JSON.parse(raw));
      admin.initializeApp({
        credential: admin.credential.cert(fromFile),
        projectId: fromFile.project_id,
      });
      console.log(`Firebase Admin initialized — project: ${fromFile.project_id}`);
    } else {
      throw new Error(
        'Set FIREBASE_SERVICE_ACCOUNT_BASE64, FIREBASE_SERVICE_ACCOUNT, GOOGLE_APPLICATION_CREDENTIALS, or FIRESTORE_EMULATOR_HOST',
      );
    }
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
