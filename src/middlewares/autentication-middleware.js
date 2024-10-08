import { response } from 'express';
import Jwt from 'jsonwebtoken';

class AutenticationMiddleware {
    AuthMiddleware = async (req, res, next) => {
        console.log("Llegué aquí");
        try {
            if (req.headers.authorization) {
                let authorizationHeader = req.headers.authorization; 
                let token = authorizationHeader.replace("Bearer ", "");
                const claveSecreta = "MaiuJuli_0607";
                let original = await Jwt.verify(token, claveSecreta);
                req.id_user = original.id;
                console.log(req.id_user);
                next();
            } else {
                return res.status(401).send("Token no proporcionado");
            }
        } catch (error) {
            console.log(error);
            return res.status(401).send("Unauthorized");
        }
    }
}

export default new AutenticationMiddleware();