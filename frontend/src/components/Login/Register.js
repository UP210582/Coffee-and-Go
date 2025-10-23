import React, { useState } from "react";
import { Input } from "@progress/kendo-react-inputs";
import { Button } from "@progress/kendo-react-buttons";
import { DropDownList } from "@progress/kendo-react-dropdowns";
import { ArrowLeft, Info } from "lucide-react";
import logo from "../../images/logo.jpg";
import { useNavigate } from "react-router-dom";
import "@progress/kendo-theme-default/dist/all.css";

const preguntas = [
  
  { value: "color", label: "¿Cuál es tu color favorito?" },
  { value: "mascota", label: "¿Nombre de tu primera mascota?" },
  { value: "ciudad", label: "¿Ciudad donde naciste?" },
];

export default function Register() {
  const navigate = useNavigate();
  const [preguntaSeleccionada, setPreguntaSeleccionada] = useState(preguntas[0]);

  return (
    <div style={{ minHeight: "100vh", background: "#fff" }}>
      {/* Header y formulario */}
      <div style={{ display: "flex", flexDirection: "column", alignItems: "center", paddingTop: 32 }}>
        
        {/* Back Button */}
        <div style={{ alignSelf: "flex-start", marginLeft: 16, marginBottom: 16 }}>
          <Button
            fillMode="flat"
            icon="arrow-left"
            onClick={() => navigate("/")}
            style={{ 
              background: "transparent",
              border: "none",
              padding: 8,
              cursor: "pointer",
              display: "inline-flex",
              alignItems: "center"
            }}
          >
            <ArrowLeft size={20} style={{ marginRight: 8 }} />
            <span style={{ fontSize: "0.875rem" }}>Atrás</span>
          </Button>
        </div>

        {/* Logo */}
        <img
          src={logo}
          alt="AUTOFIT360"
          style={{ width: 180, marginBottom: 16 }}
        />

        {/* Header Text */}
        <div style={{ marginBottom: 16, textAlign: "center", fontSize: "0.875rem" }}>
          Cree una nueva cuenta{" "}
          <Info size={18} style={{ verticalAlign: "middle", display: "inline" }} />
        </div>

        {/* Form Container */}
        <div style={{ padding: 0, width: "100%", maxWidth: 350, marginBottom: 32 }}>
          
          {/* Email Input */}
          <div style={{ marginBottom: 16 }}>
            <Input
              label="Correo electrónico"
              style={{ width: "100%" }}
            />
          </div>

          {/* Password Input */}
          <div style={{ marginBottom: 16 }}>
            <Input
              label="Contraseña"
              type="password"
              style={{ width: "100%" }}
            />
          </div>

          {/* Confirm Password Input */}
          <div style={{ marginBottom: 16 }}>
            <Input
              label="Confirmar Contraseña"
              type="password"
              style={{ width: "100%" }}
            />
          </div>

          {/* Provider Input */}
          <div style={{ marginBottom: 16 }}>
            <Input
              label="Proveedor"
              style={{ width: "100%" }}
            />
          </div>

          {/* Security Question Dropdown */}
          <div style={{ marginBottom: 16 }}>
            <label style={{ fontSize: "0.875rem", marginBottom: 4, display: "block", color: "#424242" }}>
              Seleccione una pregunta de seguridad
            </label>
            <DropDownList
              data={preguntas}
              textField="label"
              dataItemKey="value"
              value={preguntaSeleccionada}
              onChange={(e) => setPreguntaSeleccionada(e.target.value)}
              style={{ width: "100%" }}
            />
          </div>

          {/* Secret Answer Input */}
          <div style={{ marginBottom: 16 }}>
            <Input
              label="Respuesta secreta"
              style={{ width: "100%" }}
            />
          </div>

          {/* Register Button */}
          <Button
            themeColor="primary"
            fillMode="solid"
            size="large"
            style={{
              width: "100%",
              marginTop: 24,
              background: "#0d47a1",
              borderColor: "#0d47a1",
              fontWeight: 700,
              borderRadius: 8
            }}
          >
            Registrarse
          </Button>
        </div>
      </div>
    </div>
  );
}