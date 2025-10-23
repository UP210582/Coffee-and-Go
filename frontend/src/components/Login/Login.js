import React from "react";
import { useNavigate } from "react-router-dom";
import { Input } from "@progress/kendo-react-inputs";
import { Button } from "@progress/kendo-react-buttons";
import logo from "../../images/logo.jpg";
import "@progress/kendo-theme-default/dist/all.css";

export default function Login() {
  const navigate = useNavigate();

  return (
    <div style={{ minHeight: "100vh", background: "#fff" }}>
      <div style={{ display: "flex", minHeight: "100vh" }}>
        {/* Left Panel - Hidden on mobile */}
        <div
          style={{
            flex: "0 0 20%",
            background:
              "linear-gradient(rgba(5, 79, 40, 0.7), rgba(5, 79, 40, 0.7)), url('/images/apymsa-bg.jpg') center/cover",
            color: "#fff",
            display: window.innerWidth < 960 ? "none" : "flex",
            flexDirection: "column",
            justifyContent: "center",
            alignItems: "center",
            position: "relative",
          }}
        ></div>

        {/* Right Panel - Centered Login Form */}
        <div
          style={{
            flex: "1",
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            background: "#fff",
            padding: "0 16px",
          }}
        >
          <div
            style={{
              width: "100%",
              maxWidth: 400,
              textAlign: "center",
            }}
          >
            {/* Logo */}
            <div style={{ marginBottom: 24 }}>
              <img
                src={logo}
                alt="AUTOFIT360"
                style={{ width: 280, marginBottom: 16 }}
              />
            </div>

            {/* Email Input */}
            <div style={{ marginBottom: 16 }}>
              <Input label="Correo electrónico" style={{ width: "100%" }} />
            </div>

            {/* Password Input */}
            <div style={{ marginBottom: 16 }}>
              <Input
                label="Contraseña"
                type="password"
                style={{ width: "100%" }}
              />
            </div>

            {/* Login Button */}
            <Button
              themeColor="primary"
              fillMode="solid"
              size="large"
              style={{
                width: "100%",
                marginTop: 16,
                background: "#0d47a1 ",
                borderColor: "#0d47a1 ",
                fontWeight: 700,
                borderRadius: 8,
              }}
            >
              Iniciar sesión
            </Button>

            {/* Register Link */}
            <div
              style={{
                marginTop: 16,
                textAlign: "center",
                color: "#143a8c",
                cursor: "pointer",
                fontSize: "0.875rem",
              }}
              onClick={() => navigate("/register")}
            >
              Registrarse como usuario nuevo
            </div>

            {/* Forgot Password Link */}
            <div
              style={{
                marginTop: 16,
                textAlign: "center",
                color: "#e30613",
                fontSize: "0.875rem",
                cursor: "pointer",
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
