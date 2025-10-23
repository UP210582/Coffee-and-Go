import React from "react";
import {
  Box,
  Typography,
  Tabs,
  Tab,
  Grid,
  TextField,
  MenuItem,
  Button,
} from "@mui/material";
import LocalShippingOutlinedIcon from "@mui/icons-material/LocalShippingOutlined";
import LocalAtmOutlinedIcon from "@mui/icons-material/LocalAtmOutlined";
import VerifiedOutlinedIcon from "@mui/icons-material/VerifiedOutlined";

const VehicleSelector = () => {
  return (
    <>
   <Box sx={{ mt: 5, textAlign: "center", px: 4 }}>
        <Typography variant="h6" sx={{ mb: 2, color: "#003087", fontSize: "2rem" }}>
          Selecciona tu vehículo
        </Typography>

        <Box
          sx={{
            backgroundColor: "#e9ecf2",
            px: 3,
            py: 3,
            maxWidth: 1900,
            mx: "auto",
          }}
        >
          <Tabs
            value={0}
            centered
            sx={{
              mb: 2,
              ".MuiTabs-indicator": { backgroundColor: "#003087" },
              ".Mui-selected": { color: "#003087 !important", fontWeight: 700 },
            }}
          >
            <Tab label="Servicio ligero" />
            <Tab label="Servicio pesado" />
            <Tab label="Motocicletas" />
          </Tabs>

          <Grid container spacing={2} justifyContent="center" alignItems="center">
            <Grid item>
              <TextField
                select
                label="AÑO"
                size="small"
                sx={{
                  width: 150,
                  backgroundColor: "#fff",
                  borderRadius: 2,
                  "& .MuiOutlinedInput-root": { borderRadius: 2 },
                }}
              >
                <MenuItem value="2024">2024</MenuItem>
                <MenuItem value="2023">2023</MenuItem>
              </TextField>
            </Grid>
            <Grid item>
              <TextField
                select
                label="ARMADORA"
                size="small"
                sx={{
                  width: 150,
                  backgroundColor: "#fff",
                  borderRadius: 2,
                  "& .MuiOutlinedInput-root": { borderRadius: 2 },
                }}
              >
                <MenuItem value="Nissan">Nissan</MenuItem>
                <MenuItem value="Toyota">Toyota</MenuItem>
              </TextField>
            </Grid>
            <Grid item>
              <TextField
                select
                label="MODELO"
                size="small"
                sx={{
                  width: 150,
                  backgroundColor: "#fff",
                  borderRadius: 2,
                  "& .MuiOutlinedInput-root": { borderRadius: 2 },
                }}
              >
                <MenuItem value="Versa">Versa</MenuItem>
                <MenuItem value="Corolla">Corolla</MenuItem>
              </TextField>
            </Grid>
            <Grid item>
              <TextField
                select
                label="MOTOR"
                size="small"
                sx={{
                  width: 150,
                  backgroundColor: "#fff",
                  borderRadius: 2,
                  "& .MuiOutlinedInput-root": { borderRadius: 2 },
                }}
              >
                <MenuItem value="1.6">1.6</MenuItem>
                <MenuItem value="2.0">2.0</MenuItem>
              </TextField>
            </Grid>
            <Grid item>
              <Button
                variant="contained"
                sx={{
                  backgroundColor: "#e30613",
                  borderRadius: 2,
                  minWidth: 120,
                  height: 40,
                  fontWeight: 700,
                  "&:hover": { backgroundColor: "#b0000f" },
                }}
              >
                Buscar
              </Button>
            </Grid>
          </Grid>
        </Box>
      </Box>

      <Box
        sx={{
          mt: 6,
          py: 3,
          backgroundColor: "#003087",
          color: "#fff",
          display: "flex",
          justifyContent: "space-around",
          textAlign: "center",
        }}
      >
        <Box>
          <VerifiedOutlinedIcon fontSize="large" />
          <Typography variant="subtitle1" sx={{ fontWeight: 700 }}>
            Free Shipping
          </Typography>
          <Typography variant="body2">
            sed do eiusmod tempor incididunt ut
          </Typography>
        </Box>
        <Box>
          <LocalShippingOutlinedIcon fontSize="large" />
          <Typography variant="subtitle1" sx={{ fontWeight: 700 }}>
            Free Shipping
          </Typography>
          <Typography variant="body2">
            sed do eiusmod tempor incididunt ut
          </Typography>
        </Box>
        <Box>
          <LocalAtmOutlinedIcon fontSize="large" />
          <Typography variant="subtitle1" sx={{ fontWeight: 700 }}>
            Free Shipping
          </Typography>
          <Typography variant="body2">
            sed do eiusmod tempor incididunt ut
          </Typography>
        </Box>
      </Box>
    </>
  );
};

export default VehicleSelector;
