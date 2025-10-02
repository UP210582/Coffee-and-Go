import React from "react";
import { Box, Grid, Card, CardContent, Typography, CardMedia } from "@mui/material";
import ArrowForwardIosIcon from "@mui/icons-material/ArrowForwardIos";
import LocationOnIcon from "@mui/icons-material/LocationOn";
import DirectionsCarIcon from "@mui/icons-material/DirectionsCar";
import LocalShippingIcon from "@mui/icons-material/LocalShipping";

import LadoDerechoImg from "../../images/randomImagen.png";

const InformationSection = () => {
  return (
    <Box sx={{ mt: 10, px: 8 }}>
      <Grid container spacing={2} alignItems="stretch">
        <Grid item container direction="column" spacing={2}>
          <Grid item>
            <Card variant="outlined" sx={{ display: "flex", alignItems: "center", height: 130}}>
              <CardContent sx={{ flex: 1 }}>
                <Typography variant="h6" fontWeight="bold">
                  <LocationOnIcon color="error" sx={{ mr: 1 }} />
                  UBICA TU TIENDA
                </Typography>
                <Typography variant="body2" color="text.secondary" sx={{ mt: 1 }}>
                  Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor.
                </Typography>
              </CardContent>
              <ArrowForwardIosIcon color="error" sx={{ pr: 2 }} />
            </Card>
          </Grid>

          <Grid item>
            <Card variant="outlined" sx={{ display: "flex", alignItems: "center", height: 130}}>
              <CardContent sx={{ flex: 1 }}>
                <Typography variant="h6" fontWeight="bold">
                  <DirectionsCarIcon color="error" sx={{ mr: 1 }} />
                  AGREGA VEHÍCULO
                </Typography>
                <Typography variant="body2" color="text.secondary" sx={{ mt: 1 }}>
                  Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor.
                </Typography>
              </CardContent>
              <ArrowForwardIosIcon color="error" sx={{ pr: 2 }} />
            </Card>
          </Grid>

          <Grid item>
            <Card variant="outlined" sx={{ display: "flex", alignItems: "center", height: 130}}>
              <CardContent sx={{ flex: 1 }}>
                <Typography variant="h6" fontWeight="bold">
                  <LocalShippingIcon color="error" sx={{ mr: 1 }} />
                  CONVIÉRTETE EN DISTRIBUIDOR
                </Typography>
                <Typography variant="body2" color="text.secondary" sx={{ mt: 1 }}>
                  Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor.
                </Typography>
              </CardContent>
              <ArrowForwardIosIcon color="error" sx={{ pr: 2 }} />
            </Card>
          </Grid>
        </Grid>

  
         <Grid item >
          <CardMedia
            component="img"
            image={LadoDerechoImg}
            alt="Imagen derecha"
                      sx={{
              width: "750px",     
              height: "425px",   
              objectFit: "cover",
            }}
          />
        </Grid>
      </Grid>
    </Box>
  );
};

export default InformationSection;
