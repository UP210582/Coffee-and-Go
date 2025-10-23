import React from "react";
import { useNavigate } from "react-router-dom";
import { Box, Grid, Typography, TextField, Button, Paper } from "@mui/material";
import VerifiedOutlinedIcon from "@mui/icons-material/VerifiedOutlined";
import LocalShippingOutlinedIcon from "@mui/icons-material/LocalShippingOutlined";
import CardGiftcardOutlinedIcon from "@mui/icons-material/CardGiftcardOutlined";
import YouTubeIcon from "@mui/icons-material/YouTube";
import FacebookIcon from "@mui/icons-material/Facebook";
import WhatsAppIcon from "@mui/icons-material/WhatsApp";
import InstagramIcon from "@mui/icons-material/Instagram";
import Register from "./Register";

export default function Login() {
    const navigate = useNavigate();
  return (
    <Box sx={{ minHeight: "100vh", background: "#fff" }}>
      <Grid container sx={{ minHeight: "100vh" }}>
        {/* Columna izquierda: fondo azul con imagen y beneficios */}
        <Grid
          item
          xs={12}
          md={6}
          sx={{
            background: "linear-gradient(rgba(20,58,140,0.85), rgba(20,58,140,0.85)), url('/images/apymsa-bg.jpg') center/cover",
            color: "#fff",
            display: { xs: "none", md: "flex" },
            flexDirection: "column",
            justifyContent: "center",
            alignItems: "center",
            position: "relative",
            px: 20,
          }}
        >
        </Grid>

        {/* Columna derecha: login */}
        <Grid
          item
          xs={12}
          md={6}
          sx={{
            display: "flex",
            alignItems: "center",
            justifyContent: "center",
            background: "#fff",
            py: 2,
          }}
        >
          <Paper elevation={0} sx={{ p: 15, width: "100%", maxWidth: 350 }}>
            <Box sx={{ textAlign: "center", mb: 3 }}>
              <img
                src="https://www.apymsa.com.mx/Content/Images/Logo-Apymsa-2024.png"
                alt="APYMSA"
                style={{ width: 180, marginBottom: 16 }}
              />
            </Box>
            <TextField
              label="Correo electrónico"
              fullWidth
              margin="normal"
              size="small"
            />
            <TextField
              label="Contraseña"
              type="password"
              fullWidth
              margin="normal"
              size="small"
            />
            <Button
              variant="contained"
              fullWidth
              sx={{
                mt: 2,
                background: "#e30613",
                color: "#fff",
                fontWeight: 700,
                borderRadius: 2,
                "&:hover": { background: "#b0000f" },
              }}
            >
              Iniciar sesión
            </Button>
            <Typography
      variant="body2"
      sx={{ mt: 2, textAlign: "center", color: "#143a8c", cursor: "pointer" }}
      onClick={() => navigate("/register")}
    >
      Registrarse como usuario nuevo
    </Typography>
            <Typography variant="body2" sx={{ mt: 2, textAlign: "center", color: "#e30613" }}>
              ¿Olvidaste tu contraseña?
            </Typography>
          </Paper>
        </Grid>
      </Grid>
    </Box>
  );
}