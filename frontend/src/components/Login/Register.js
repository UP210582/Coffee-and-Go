import React from "react";
import {
  Box,
  Typography,
  TextField,
  Button,
  MenuItem,
  Paper,
  IconButton,
} from "@mui/material";
import ArrowBackIcon from "@mui/icons-material/ArrowBack";
import InfoOutlinedIcon from "@mui/icons-material/InfoOutlined";
import YouTubeIcon from "@mui/icons-material/YouTube";
import FacebookIcon from "@mui/icons-material/Facebook";
import WhatsAppIcon from "@mui/icons-material/WhatsApp";
import InstagramIcon from "@mui/icons-material/Instagram";

const preguntas = [
  { value: "", label: "Seleccione una pregunta de seguridad" },
  { value: "color", label: "¿Cuál es tu color favorito?" },
  { value: "mascota", label: "¿Nombre de tu primera mascota?" },
  { value: "ciudad", label: "¿Ciudad donde naciste?" },
];

export default function Register() {
  return (
    <Box sx={{ minHeight: "100vh", background: "#fff" }}>
      {/* Header y formulario */}
      <Box sx={{ display: "flex", flexDirection: "column", alignItems: "center", pt: 4 }}>
        <Box sx={{ alignSelf: "flex-start", ml: 2, mb: 2 }}>
          <IconButton>
            <ArrowBackIcon />
          </IconButton>
          <Typography variant="body2" sx={{ display: "inline", ml: 1 }}>
            Atrás
          </Typography>
        </Box>
        <img
          src="https://www.apymsa.com.mx/Content/Images/Logo-Apymsa-2024.png"
          alt="APYMSA"
          style={{ width: 180, marginBottom: 16 }}
        />
        <Typography variant="body2" sx={{ mb: 2, textAlign: "center" }}>
          Cree una nueva cuenta <InfoOutlinedIcon fontSize="small" sx={{ verticalAlign: "middle" }} />
        </Typography>
        <Paper elevation={0} sx={{ p: 4, width: "100%", maxWidth: 350, boxShadow: "none", mb: 4 }}>
          <TextField
            label="Correo electrónico"
            fullWidth
            margin="normal"
            size="small"
          />
          <TextField
            label="RFC"
            fullWidth
            margin="normal"
            size="small"
          />
          <TextField
            label="Cliente ID"
            fullWidth
            margin="normal"
            size="small"
          />
          <TextField
            label="Proveedor"
            fullWidth
            margin="normal"
            size="small"
          />
          <TextField
            select
            label="Seleccione una pregunta de seguridad"
            fullWidth
            margin="normal"
            size="small"
            defaultValue=""
          >
            {preguntas.map((option) => (
              <MenuItem key={option.value} value={option.value}>
                {option.label}
              </MenuItem>
            ))}
          </TextField>
          <TextField
            label="Respuesta secreta"
            fullWidth
            margin="normal"
            size="small"
          />
          <Button
            variant="contained"
            fullWidth
            sx={{
              mt: 3,
              background: "#e30613",
              color: "#fff",
              fontWeight: 700,
              borderRadius: 2,
              "&:hover": { background: "#b0000f" },
            }}
          >
            Registrarse
          </Button>
        </Paper>
      </Box>
      {/* Footer azul */}
      <Box sx={{
        background: "#143a8c",
        color: "#fff",
        py: 4,
        px: 2,
        display: "flex",
        flexDirection: { xs: "column", md: "row" },
        justifyContent: "space-between",
        alignItems: "flex-start",
        gap: 4,
        width: "100%",
        mt: 0,
      }}>
        <Box>
          <Typography variant="body1" sx={{ fontWeight: 700, mb: 2 }}>
            &gt; Quienes somos
          </Typography>
          <Typography variant="body1" sx={{ mb: 1 }}>
            &gt; Responsabilidad Social
          </Typography>
          <Typography variant="body1" sx={{ mb: 1 }}>
            &gt; Solicitud de crédito
          </Typography>
          <Typography variant="body1" sx={{ mb: 1 }}>
            &gt; Descarga de códigos SAT
          </Typography>
        </Box>
        <Box>
          <Typography variant="body1" sx={{ fontWeight: 700, mb: 2 }}>
            Datos de Contacto
          </Typography>
          <Typography variant="body1" sx={{ mb: 1 }}>
            &gt; Lorem ipsum dolor sit amet,
          </Typography>
          <Typography variant="body1" sx={{ mb: 1 }}>
            &gt; sed do eiusmod tempor incididunt
          </Typography>
          <Typography variant="body1" sx={{ mb: 1 }}>
            &gt; Ut enim ad minim veniam
          </Typography>
        </Box>
        <Box>
          <Typography variant="body1" sx={{ fontWeight: 700, mb: 2 }}>
            Contáctanos
          </Typography>
          <Box sx={{ display: "flex", gap: 2 }}>
            <YouTubeIcon fontSize="large" />
            <FacebookIcon fontSize="large" />
            <WhatsAppIcon fontSize="large" />
            <InstagramIcon fontSize="large" />
          </Box>
        </Box>
      </Box>
    </Box>
  );
}