import { Request, Response } from "express";
import { CreateUserDto } from "./dtos/CreateUser.dto";
import AuthService from "./auth-service";

class AuthController {
  private authService: AuthService;

  constructor(authService: AuthService) {
    this.authService = authService;
  }

  registerUser = async (req: Request, res: Response): Promise<void> => {
    try {
      const createUserDto: CreateUserDto = req.body;
      const user = await this.authService.registerUser(createUserDto);
      res.status(201).json(user);
    } catch (err) {
      console.error("Error registering user:", err); // Log the error
      res.status(500).json({ message: "Error registering user" });
    }
  };

  loginUser = async (req: Request, res: Response) => {
    try {
      const { identifier, password } = req.body;
      const result = await this.authService.loginUser(identifier, password);
  
      if (!result) {
        return res.status(401).json({ message: 'Invalid credentials' });
      }
      res.json(result);
    } catch (err) {
      console.error('login error →', err);   // ← покажет реальную причину
      res.status(500).json({ message: 'Error logging in' });
    }
  };

  getAllUsers = async (req: Request, res: Response): Promise<void> => {
    try {
      const result = await this.authService.getAllUsers();
      if(!result) {
        res.status(404).json({ message: "No users found" });
        return;
      }
      res.status(200).json(result);
    } catch (error) {
      res.status(500).json({ message: "Error getting users" });
    }
  }

  refreshToken = async (req: Request, res: Response): Promise<void> => {
    try {
      const { token } = req.body;
      const result = await this.authService.refreshToken(token);
      if (!result) {
        res.status(401).json({ message: "Invalid or expired refresh token" });
        return;
      }
      res.status(200).json(result);
    } catch (err) {
      res.status(500).json({ message: "Error refreshing token" });
    }
  };
}

export default AuthController;
