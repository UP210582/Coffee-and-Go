import React from "react";
import { Box, Typography, Paper } from "@mui/material";
import YouTubeIcon from "@mui/icons-material/YouTube";
import FacebookIcon from "@mui/icons-material/Facebook";
import WhatsAppIcon from "@mui/icons-material/WhatsApp";
import InstagramIcon from "@mui/icons-material/Instagram";

const tiendas = [
  {
    nombre: "Aguascalientes Convención",
    direccion: "Av. Convención de 1914 Sur # 1106 20270, Col. Jardines de la Asunción.",
    telefonos: "4499134545, 4493971498, 44939717148",
  },
  {
    nombre: "Aguascalientes Convención",
    direccion: "Av. Convención de 1914 Sur # 1106 20270, Col. Jardines de la Asunción.",
    telefonos: "4499134545, 4493971498, 44939717148",
  },
];

export default function LocationResult() {
  return (
    <>
      <Box sx={{
        display: "flex",
        gap: 3,
        background: "#f2f4f8",
        borderRadius: 2,
        p: 2,
        maxWidth: 1350,
        mx: "auto",
        mt: 4,
      }}>
        {/* Mapa */}
        <Box sx={{ flex: 1 }}>
          <iframe
            title="Mapa"
            src="https://www.google.com/maps/embed?pb=!1m18!1m12!1m3!1d3723.760964409775!2d-101.684!3d21.8818!2m3!1f0!2f0!3f0!3m2!1i1024!2i768!4f13.1!3m3!1m2!1s0x8429e9c6e7b7e7e7%3A0x7e7e7e7e7e7e7e7e!2sAguascalientes!5e0!3m2!1ses!2smx!4v1630000000000!5m2!1ses!2smx"
            width="100%"
            height="400"
            style={{ border: 0, borderRadius: "12px" }}
            allowFullScreen=""
            loading="lazy"
          />
        </Box>
        {/* Tiendas */}
        <Box sx={{ flex: 1, display: "flex", flexDirection: "column", gap: 2 }}>
          <Typography variant="subtitle1" sx={{ mb: 2, textAlign: "center" }}>
            Estas son tus tiendas más cercanas:
          </Typography>
          {tiendas.map((tienda, idx) => (
            <Paper key={idx} sx={{ p: 2, border: "1px solid #e0e0e0", borderRadius: 2 }}>
              <Typography variant="subtitle1" sx={{ color: "#d32f2f", fontWeight: 700 }}>
                {tienda.nombre}
              </Typography>
              <Typography variant="body2" sx={{ mb: 1 }}>
                {tienda.direccion}
              </Typography>
              <Typography variant="body2" sx={{ fontWeight: 700 }}>
                Teléfonos:
              </Typography>
              <Typography variant="body2">{tienda.telefonos}</Typography>
            </Paper>
          ))}
        </Box>
      </Box>
      {/* Footer azul debajo de todo */}
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
        mt: 4,
      }}>
        {/* Columna 1 */}
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
        {/* Columna 2 */}
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
        {/* Columna 3 */}
        <Box>
          <Typography variant="body1" align="center" sx={{ fontWeight: 700, mb: 2, fontSize: "1.5rem"}}>
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
    </>
  );
}