import admin from 'firebase-admin';
import { readFileSync } from 'fs';
import path from 'path';

// Load the service account key JSON file
const serviceAccount = JSON.parse(readFileSync(path.resolve('./firebase/serviceAccountKey.json'), 'utf8'));

admin.initializeApp({
    credential: admin.credential.cert(serviceAccount),
});

export default admin;