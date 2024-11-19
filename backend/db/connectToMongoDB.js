import mongoose from "mongoose";

const connectToMongoDB = async () => {
    try {
        // const url = process.env.MONGODB_URI;
        mongoose.connect(`mongodb+srv://${process.env.DB_USERNAME}:${process.env.DB_PASS}@cluster0.ehrzjjy.mongodb.net/mic-chat-db`)
            .then(async () => {

                console.log("Connected to MongoDB");
            }
            )
            .catch(err => console.error('Error connecting to database:'));

    } catch (error) {
        console.log("Error connecting to MongoDB", error.message);
    }
}

export default connectToMongoDB;