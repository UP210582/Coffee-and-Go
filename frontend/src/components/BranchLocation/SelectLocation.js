import React from "react";
import { Box, Grid, Typography, TextField, MenuItem } from "@mui/material";

const estados = [
  { value: "", label: "Selecciona un Estado" },
  { value: "Jalisco", label: "Jalisco" },
  { value: "CDMX", label: "CDMX" },
];

const ciudades = [
  { value: "", label: "Selecciona una Ciudad" },
  { value: "Guadalajara", label: "Guadalajara" },
  { value: "Zapopan", label: "Zapopan" },
];

export default function SelectLocation() {
  const [estado, setEstado] = React.useState("");
  const [ciudad, setCiudad] = React.useState("");

  return (
    <Box
      sx={{
        backgroundColor: "#e9ecf2",
        borderRadius: 2,
        px: 2,
        py: 2,
        maxWidth: 1350,
        mx: "auto",
        mt: 5,
      }}
    >
      <Grid
        container
        alignItems="center"
        justifyContent="center"
        spacing={2}
      >
        <Grid item xs={12} md={4}>
          <Typography variant="body1" sx={{ fontWeight: 400 }}>
            Selecciona tu estado y ciudad<br />
            para encontrar tu tienda Apymysa<br />
            más cercana.
          </Typography>
        </Grid>
        <Grid item xs={12} md={4}>
          <TextField
            select
            fullWidth
            size="small"
            value={estado}
            onChange={e => setEstado(e.target.value)}
            variant="outlined"
            sx={{
              minWidth: 260,
              background: "#fff",
              "& .MuiSelect-select": {
                color: estado ? "#222" : "#888",
              },
            }}
            displayEmpty
            renderValue={(selected) =>
              selected
                ? estados.find((option) => option.value === selected)?.label
                : <span style={{ color: "#888" }}>Selecciona un Estado</span>
            }
          >
            {estados.map((option) => (
              <MenuItem key={option.value} value={option.value}>
                {option.label}
              </MenuItem>
            ))}
          </TextField>
        </Grid>
        <Grid item xs={12} md={4}>
          <TextField
            select
            fullWidth
            size="small"
            value={ciudad}
            onChange={e => setCiudad(e.target.value)}
            variant="outlined"
            sx={{
              minWidth: 260,
              background: "#fff",
              "& .MuiSelect-select": {
                color: ciudad ? "#222" : "#888",
              },
            }}
            displayEmpty
            renderValue={(selected) =>
              selected
                ? ciudades.find((option) => option.value === selected)?.label
                : <span style={{ color: "#888" }}>Selecciona una Ciudad</span>
            }
          >
            {ciudades.map((option) => (
              <MenuItem key={option.value} value={option.value}>
                {option.label}
              </MenuItem>
            ))}
          </TextField>
        </Grid>
      </Grid>
    </Box>
  );
}