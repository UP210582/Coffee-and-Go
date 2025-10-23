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

export default function UserType() {
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
          <Box sx={{ width: "100%", maxWidth: 350 }}>
            <Box sx={{ mb: 4 }}>
              <VerifiedOutlinedIcon sx={{ fontSize: 48 }} />
              <Typography variant="h6" fontWeight="bold">
                Free Shipping
              </Typography>
              <Typography variant="body2">
                sed do eiusmod tempor incididunt ut
              </Typography>
            </Box>
            <Box sx={{ mb: 4 }}>
              <CardGiftcardOutlinedIcon sx={{ fontSize: 48 }} />
              <Typography variant="h6" fontWeight="bold">
                Free Shipping
              </Typography>
              <Typography variant="body2">
                sed do eiusmod tempor incididunt ut
              </Typography>
            </Box>
            <Box sx={{ mb: 4 }}>
              <LocalShippingOutlinedIcon sx={{ fontSize: 48 }} />
              <Typography variant="h6" fontWeight="bold">
                Free Shipping
              </Typography>
              <Typography variant="body2">
                sed do eiusmod tempor incididunt ut
              </Typography>
            </Box>
          </Box>
        </Grid>
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
          <Paper elevation={0} sx={{ p: 35, width: "100%", maxWidth: 350 }}>
            <Box sx={{ textAlign: "center", mb: 3 }}>
              <img
                src="https://www.apymsa.com.mx/Content/Images/Logo-Apymsa-2024.png"
                alt="APYMSA"
                style={{ width: 180, marginBottom: 16 }}
              />
            </Box>
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
              Refaccionaría
            </Button>

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
              Proveedor
            </Button>
            <Typography
      variant="body2"
      sx={{ mt: 2, textAlign: "center", color: "#143a8c", cursor: "pointer" }}
      onClick={() => navigate("/register")}
    >
      Registrarse como usuario nuevo
    </Typography>
          </Paper>
        </Grid>
      </Grid>
      {/* Footer */}
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
           <YouTubeIcon fontSize="large" />
            <FacebookIcon fontSize="large" />
            <WhatsAppIcon fontSize="large" />
            <InstagramIcon fontSize="large" />
        
        </Box>
      </Box>
    </Box>
  );
}