import express from "express";
import { loadUserData, login, logout, signup } from "../controllers/auth.controller.js";
import protectRoute from "../middleware/protectRoute.js";

const router = express.Router();

router.post("/signup", signup)

router.post("/login", login)

router.post("/logout", logout)

router.get("/user", protectRoute, loadUserData)


export default router;