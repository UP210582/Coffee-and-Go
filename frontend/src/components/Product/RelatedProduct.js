import React, { useState } from "react";
import { Box, Typography, Card, CardContent, IconButton } from "@mui/material";
import ArrowBackIosIcon from "@mui/icons-material/ArrowBackIos";
import ArrowForwardIosIcon from "@mui/icons-material/ArrowForwardIos";
import YouTubeIcon from "@mui/icons-material/YouTube";
import FacebookIcon from "@mui/icons-material/Facebook";
import WhatsAppIcon from "@mui/icons-material/WhatsApp";
import InstagramIcon from "@mui/icons-material/Instagram";

const products = [
  { title: "Title", description: "Body text for whatever you'd like to say. Add main takeaway points, quotes, anecdotes, or even a very very short story." },
  { title: "Title", description: "Body text for whatever you'd like to say. Add main takeaway points, quotes, anecdotes, or even a very very short story." },
  { title: "Title", description: "Body text for whatever you'd like to say. Add main takeaway points, quotes, anecdotes, or even a very very short story." },
  { title: "Title", description: "Body text for whatever you'd like to say. Add main takeaway points, quotes, anecdotes, or even a very very short story." },
  { title: "Title", description: "Body text for whatever you'd like to say. Add main takeaway points, quotes, anecdotes, or even a very very short story." },
];

const VISIBLE_CARDS = 4;

export default function RelatedProduct() {
  const [startIdx, setStartIdx] = useState(0);

  const handlePrev = () => {
    setStartIdx((prev) => Math.max(prev - 1, 0));
  };

  const handleNext = () => {
    setStartIdx((prev) => Math.min(prev + 1, products.length - VISIBLE_CARDS));
  };

  return (
    <>
      {/* Carrusel */}
      <Box sx={{ background: "#fff", py: 6 }}>
        <Typography variant="h5" align="center" sx={{ color: "#003087", fontWeight: 700, mb: 4, fontSize: "2rem" }}>
          Productos Relacionados
        </Typography>
        <Box sx={{ position: "relative", maxWidth: 1200, mx: "auto", px: 2 }}>
          <IconButton
            onClick={handlePrev}
            disabled={startIdx === 0}
            sx={{ position: "absolute", left: 0, top: "40%", zIndex: 1 }}
          >
            <ArrowBackIosIcon fontSize="large" />
          </IconButton>
          <Box
            sx={{
              display: "flex",
              overflow: "hidden",
              gap: 2,
              ml: 6,
              mr: 6,
            }}
          >
            {products.slice(startIdx, startIdx + VISIBLE_CARDS).map((product, idx) => (
              <Card key={idx} sx={{ minWidth: 220, background: "#f5f7fa", boxShadow: 0 }}>
                <CardContent sx={{ textAlign: "center" }}>
                  <Box sx={{ mb: 2, height: 80, background: "#eaeaea", borderRadius: 2 }}>
                    <img src="../../images/img.png" alt="img" style={{ width: "60px", marginTop: "10px", opacity: 0.5 }} />
                  </Box>
                  <Typography variant="subtitle1" fontWeight="bold">{product.title}</Typography>
                  <Typography variant="body2" sx={{ mt: 1, color: "#444" }}>{product.description}</Typography>
                </CardContent>
              </Card>
            ))}
          </Box>
          <IconButton
            onClick={handleNext}
            disabled={startIdx >= products.length - VISIBLE_CARDS}
            sx={{ position: "absolute", right: 0, top: "40%", zIndex: 1 }}
          >
            <ArrowForwardIosIcon fontSize="large" />
          </IconButton>
          <Box sx={{ display: "flex", justifyContent: "center", mt: 2 }}>
            {[...Array(products.length - VISIBLE_CARDS + 1)].map((_, idx) => (
              <Box key={idx} sx={{
                width: 8, height: 8, borderRadius: "50%", background: idx === startIdx ? "#003087" : "#ccc", mx: 0.5
              }} />
            ))}
          </Box>
        </Box>
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