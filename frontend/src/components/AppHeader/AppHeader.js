import React, { useState } from "react";
import { useNavigate } from "react-router-dom";
import {
  AppBar,
  Toolbar,
  IconButton,
  Button,
  Avatar,
  Modal,
  Box,
} from "@mui/material";
import MenuIcon from "@mui/icons-material/Menu";
import SearchIcon from "@mui/icons-material/Search";
import LocationOnIcon from "@mui/icons-material/LocationOn";
import ShoppingCartIcon from "@mui/icons-material/ShoppingCart";
import AccountCircleIcon from "@mui/icons-material/AccountCircle";
import { styled, alpha } from "@mui/material/styles";
import InputBase from "@mui/material/InputBase";
import Login from "../Login/Login"; 
//import CatalogScreen from "../Catalog/CatalogScreen";

const Search = styled("div")(({ theme }) => ({
  position: "relative",
  borderRadius: theme.shape.borderRadius * 2,
  backgroundColor: alpha(theme.palette.primary.light, 0.1),
  "&:hover": {
    backgroundColor: alpha(theme.palette.primary.light, 0.15),
  },
  marginLeft: theme.spacing(2),
  flexGrow: 1,
  display: "flex",
  alignItems: "center",
  padding: "0 10px",
}));

const SearchIconWrapper = styled("div")(({ theme }) => ({
  padding: theme.spacing(0, 2),
  height: "100%",
  position: "absolute",
  pointerEvents: "none",
  display: "flex",
  alignItems: "center",
  justifyContent: "center",
}));

const StyledInputBase = styled(InputBase)(({ theme }) => ({
  color: "inherit",
  "& .MuiInputBase-input": {
    padding: theme.spacing(1, 1, 1, 0),
    paddingLeft: `calc(1em + ${theme.spacing(4)})`,
    transition: theme.transitions.create("width"),
    width: "100%",
    [theme.breakpoints.up("sm")]: {
      width: "20ch",
      "&:focus": {
        width: "28ch",
      },
    },
  },
}));

const AppHeader = () => {
  const [openLogin, setOpenLogin] = useState(false);
  const navigate = useNavigate();

  return (
    <>
      <AppBar
        position="static"
        color="default"
        elevation={0}
        sx={{ backgroundColor: "#fff", borderBottom: "1px solid #e0e0e0" }}
      >
        <Toolbar sx={{ display: "flex", gap: 2 }}>
          <IconButton edge="start" color="inherit">
            <MenuIcon />
          </IconButton>
          <img
            src="https://www.apymsa.com.mx/Content/Images/Logo-Apymsa-2024.png"
            alt="Logo APYMSA"
            style={{ height: 40 }}
          />
          <Search>
            <SearchIconWrapper>
              <SearchIcon />
            </SearchIconWrapper>
            <StyledInputBase placeholder="Buscar..." />
          </Search>
          <Button
            variant="contained"
            sx={{
              backgroundColor: "#e30613",
              "&:hover": { backgroundColor: "#b0000f" },
            }}
             //onClick={() => navigate("/catalog")}
          >
            Catálogo
          </Button>
          <Button
            variant="contained"
            sx={{
              backgroundColor: "#003087",
              "&:hover": { backgroundColor: "#001f57" },
            }}
          >
            Sucursales
          </Button>
          <IconButton color="error">
            <LocationOnIcon />
          </IconButton>
          <IconButton color="inherit">
            <ShoppingCartIcon />
          </IconButton>
           <IconButton onClick={() => navigate("/login")}>
          <Avatar sx={{ bgcolor: "#e0e0e0" }}>
            <AccountCircleIcon color="action" />
          </Avatar>
        </IconButton>
        </Toolbar>
      </AppBar>
      <Modal open={openLogin} onClose={() => setOpenLogin(false)}>
        <Box sx={{
          position: "absolute",
          top: "50%",
          left: "50%",
          transform: "translate(-50%, -50%)",
          bgcolor: "#fff",
          boxShadow: 24,
          borderRadius: 2,
          p: 0,
          minWidth: 400,
        }}>
          <Login />
        </Box>
      </Modal>
    </>
  );
};

export default AppHeader;