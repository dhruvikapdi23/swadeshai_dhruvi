const bcrypt = require('bcryptjs');
const { getDb } = require('../config/firebase');

const USERS_COLLECTION = 'users';
const SALT_ROUNDS = 10;

function toPublicUser(doc) {
  const data = doc.data();
  return {
    id: doc.id,
    name: data.name,
    email: data.email,
    createdAt: data.createdAt,
  };
}

async function getUserById(userId) {
  const doc = await getDb().collection(USERS_COLLECTION).doc(userId).get();
  if (!doc.exists) return null;
  return toPublicUser(doc);
}

async function getUserDocByEmail(email) {
  const normalized = email.trim().toLowerCase();
  const snapshot = await getDb()
    .collection(USERS_COLLECTION)
    .where('email', '==', normalized)
    .limit(1)
    .get();

  if (snapshot.empty) return null;
  return snapshot.docs[0];
}

function validateCredentials({ name, email, password }) {
  if (!name?.trim() || !email?.trim() || !password) {
    const error = new Error('name, email, and password are required');
    error.status = 400;
    throw error;
  }

  if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(email.trim())) {
    const error = new Error('Invalid email format');
    error.status = 400;
    throw error;
  }

  if (password.length < 6) {
    const error = new Error('Password must be at least 6 characters');
    error.status = 400;
    throw error;
  }
}

async function registerUser({ name, email, password, deviceToken }) {
  validateCredentials({ name, email, password });

  const existing = await getUserDocByEmail(email);
  if (existing) {
    const error = new Error('A user with this email already exists');
    error.status = 409;
    throw error;
  }

  const db = getDb();
  const ref = db.collection(USERS_COLLECTION).doc();
  const passwordHash = await bcrypt.hash(password, SALT_ROUNDS);
  const normalizedEmail = email.trim().toLowerCase();

  const userData = {
    name: name.trim(),
    email: normalizedEmail,
    passwordHash,
    deviceToken: deviceToken || null,
    createdAt: new Date().toISOString(),
    updatedAt: new Date().toISOString(),
  };

  await ref.set(userData);

  return {
    id: ref.id,
    name: userData.name,
    email: userData.email,
    createdAt: userData.createdAt,
  };
}

async function loginUser({ email, password, deviceToken }) {
  if (!email?.trim() || !password) {
    const error = new Error('email and password are required');
    error.status = 400;
    throw error;
  }

  const doc = await getUserDocByEmail(email);
  if (!doc) {
    const error = new Error('Invalid email or password');
    error.status = 401;
    throw error;
  }

  const data = doc.data();
  const valid = await bcrypt.compare(password, data.passwordHash);
  if (!valid) {
    const error = new Error('Invalid email or password');
    error.status = 401;
    throw error;
  }

  if (deviceToken) {
    await doc.ref.update({
      deviceToken,
      updatedAt: new Date().toISOString(),
    });
  }

  return toPublicUser(doc);
}

module.exports = {
  getUserById,
  registerUser,
  loginUser,
};
