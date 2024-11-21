import express from "express";
import { checkMessages, getMessages, sendFirstMessage, sendMessage } from "../controllers/message.controller.js";
import protectRoute from "../middleware/protectRoute.js";

const router = express.Router();

router.post("/send/:id", protectRoute, sendMessage)
router.post("/sendFirst", protectRoute, sendFirstMessage)
router.get("/:id", protectRoute, getMessages)
router.get("/check/:id", protectRoute, checkMessages)

export default router;
