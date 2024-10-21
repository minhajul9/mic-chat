import { useState } from 'react'
import toast from 'react-hot-toast';

const useSignup = () => {
    const [loading, setLoading] = useState(false);
    //@ts-ignore
    const signUp = async ({ fullName, username, password, confirmPassword, gender }) => {

        setLoading(true)

        const success = handleInputErrors({ fullName, username, password, confirmPassword, gender });

        if (!success) return;

        try {
            const res = await fetch("/api/auth/signup", {
                method: "POST",
                headers: {
                    "content-type": "application/json"
                },
                body: JSON.stringify({ fullName, username, password, confirmPassword, gender })
            });

            const data = await res.json();

            console.log(data);

        } catch (error) {
            toast.error(error.message);
        }
        finally {
            setLoading(false);
        }
    }

    return { loading, signUp }
}

export default useSignup

//@ts-ignore
const handleInputErrors = ({ fullName, username, password, confirmPassword, gender }) => {
    if (!fullName || !username || !password || !confirmPassword || !gender) {
        toast.error("Fill all fields.")
        return false;
    }

    if (password !== confirmPassword) {
        toast.error("Passwords do not match.")
        return false;
    }

    if (password.length < 6) {
        toast.error("Password is too short.")
        return false;
    }

    return true;
}
