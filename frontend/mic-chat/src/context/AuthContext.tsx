import { createContext, ReactNode, useContext, useState } from "react";

interface AuthContextProviderProps {
    children: ReactNode;
}

export const AuthContext = createContext();

export const useAuthContext = () => {
    return useContext(AuthContext);
}


export const AuthContextProvider = ({ children }: AuthContextProviderProps) => {

    const [authUser, setAuthUser] = useState(() => {
        const savedUser = localStorage.getItem("chat-user");
        return savedUser ? JSON.parse(savedUser) : null;
    });

    return <AuthContext.Provider value={{ authUser, setAuthUser }}>
        {children}
    </AuthContext.Provider>
}
