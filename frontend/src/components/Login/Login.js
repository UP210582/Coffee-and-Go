import React from "react";
import { useNavigate } from "react-router-dom";
import { Input } from "@progress/kendo-react-inputs";
import { Button } from "@progress/kendo-react-buttons";
import { Label } from "@progress/kendo-react-labels";
import logo from "../../images/logo.jpg";
import fondo from "../../images/fondo_apymsa.png";

export default function Login() {
  const navigate = useNavigate();

  return (
    <div style={{ minHeight: "100vh", background: "#fff" }}>
      <div style={{ display: "flex", minHeight: "100vh" }}>
        {/* Columna izquierda: fondo con imagen */}
        <div
          style={{
            flex: 1,
            backgroundImage: `linear-gradient(rgba(128,128,128,0.3), rgba(128,128,128,0.3)), url(${fondo})`,
            backgroundPosition: "center",
            backgroundRepeat: "no-repeat",
            backgroundSize: "cover",
            color: "#fff",
            display: window.innerWidth >= 960 ? "flex" : "none",
            flexDirection: "column",
            justifyContent: "center",
            alignItems: "center",
          }}
        />

        {/* Columna derecha: login */}
        <div
          style={{
            flex: 1,
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            background: "#fff",
          }}
        >
          <div
            style={{
              width: "100%",
              maxWidth: 400,
              padding: "20px 40px",
              display: "flex",
              flexDirection: "column",
              alignItems: "center"
            }}
          >
            <img
              src={logo}
              alt="Autofit 360"
              style={{ width: 200, marginBottom: 40 }}
            />

            <Input
          
              type="email"
                style={{ 
                width: "100%", 
                marginBottom: 16,
                height: "40px",
                fontSize: "16px",
                padding: "0 15px",
                borderRadius: "8px", // Esquinas redondeadas
                border: "1px solid #E0E0E0", // Borde más tenue
                outline: "none" // Elimina el contorno al hacer focus
              }}
              placeholder="Correo electrónico"
            />

            <Input
              type="password"
                style={{ 
                width: "100%", 
                marginBottom: 16,
                height: "40px",
                fontSize: "16px",
                padding: "0 15px",
                borderRadius: "8px", // Esquinas redondeadas
                border: "1px solid #E0E0E0", // Borde más tenue
                outline: "none" // Elimina el contorno al hacer focus
              }}
              placeholder="Contraseña"
            />

            <Button
              style={{
                width: "100%",
                backgroundColor: "#00A651",
                color: "#fff",
                fontWeight: 500,
                borderRadius: 4,
                padding: "10px",
                border: "none"
              }}
            >
              INICIAR SESIÓN
            </Button>

            <div
              style={{
                marginTop: 16,
                textAlign: "center",
                cursor: "pointer",
                color: "#666"
              }}
              onClick={() => navigate("/register")}
            >
              Registrarse como usuario nuevo
            </div>

            <div
              style={{
                marginTop: 16,
                textAlign: "center",
                color: "#e30613",
                cursor: "pointer"
              }}
            >
              ¿Olvidaste tu contraseña?
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}