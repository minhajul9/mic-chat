import express from "express";
import protectRoute from "../middleware/protectRoute.js";
import { getConversations, getUsersForSidebar } from "../controllers/user.controller.js";

const router = express.Router();

router.get('/', protectRoute, getUsersForSidebar);

router.get('/conversations/:userId', getConversations);

export default router;
