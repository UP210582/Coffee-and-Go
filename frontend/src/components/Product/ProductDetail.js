import { Box, Typography, Button } from "@mui/material";
import Img from "../../images/img.png";

export default function ImagenesProducto() {
  return (
    <div style={{ padding: "50px" }}>
      <div style={{ display: "flex", gap: "50px" }}>
        {/* Columna de 3 imágenes pequeñas */}
        <div style={{ display: "flex", flexDirection: "column", gap: "30px" }}>
          {[1, 2, 3].map((i) => (
            <img
              key={i}
              src={Img}
              alt={`Thumbnail ${i}`}
              style={{
                width: "125px",
                height: "125px",
                objectFit: "cover",
              }}
            />
          ))}
        </div>

        {/* Imagen principal */}
        <div>
          <img
            src={Img}
            alt="Imagen principal"
            style={{
              width: "500px",
              height: "435px",
            }}
          />
        </div>

        {/* Información del producto */}
        <div className="flex flex-col justify-center px-6">
          <Typography variant="h6" fontWeight="bold" sx={{ mb: 2 }}>
            BUJIA PLATINO CHEVROLET COLORADO 2.5L. MOD. 15 19 NGK LTR5GP
          </Typography>
          <Typography variant="body2" sx={{ mb: 1 }}>
            Marca
          </Typography>
          <Typography variant="body2" sx={{ mb: 1, color: "blue" }}>
            Código: 0779946
          </Typography>
          <Typography
            variant="body2"
            sx={{
              mb: 1,
              textDecoration: "underline",
              color: "#000",
              cursor: "pointer",
            }}
          >
            Ficha técnica
          </Typography>
          <Typography variant="body2" sx={{ mb: 2 }}>
            Cantidad: 1 Electrodos
          </Typography>
          <Box sx={{ mt: 3, display: "flex", gap: 2 }}>
            <Button
  variant="contained"
  sx={{
    backgroundColor: "#000",
    color: "#fff",
    "&:hover": {
      backgroundColor: "#222",
    },
  }}
>
  Ver aplicaciones
</Button>
            <Button
  variant="contained"
  sx={{
    backgroundColor: "#000",
    color: "#fff",
    "&:hover": {
      backgroundColor: "#222",
    },
  }}
>
  Ver referencias
</Button>
          </Box>
        </div>
      </div>
    </div>
  );
}