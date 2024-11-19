import express from "express";
import generateToken from "../utils/generateToken.js";

const router = express.Router();

router.put('/create', generateToken);


export default router;