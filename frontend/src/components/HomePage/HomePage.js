import React, { useState } from "react";
import "./App.css";
import axios from "axios";
import {
  AppBar,
  Box,
  Button,
  Container,
  Dialog,
  DialogActions,
  DialogContent,
  DialogTitle,
  IconButton,
  Typography,
  Grid,
  Card,
  CardContent,
  List,
  ListItem,
  ListItemText,
  Paper,
  Stack,
  Link,
} from "@mui/material";
import YouTubeIcon from "@mui/icons-material/YouTube";
import FacebookIcon from "@mui/icons-material/Facebook";
import WhatsAppIcon from "@mui/icons-material/WhatsApp";
import InstagramIcon from "@mui/icons-material/Instagram";
import CloseIcon from "@mui/icons-material/Close";
import CloudUploadIcon from "@mui/icons-material/CloudUpload";
import DeleteIcon from "@mui/icons-material/Delete";
import { Accordion, AccordionSummary, AccordionDetails } from "@mui/material";
import ExpandMoreIcon from "@mui/icons-material/ExpandMore";

function formatFileSize(bytes) {
  if (bytes === 0) return "0 Bytes";
  const k = 1024;
  const sizes = ["Bytes", "KB", "MB", "GB"];
  const i = Math.floor(Math.log(bytes) / Math.log(k));
  return parseFloat((bytes / Math.pow(k, i)).toFixed(2)) + " " + sizes[i];
}

const App = () => {
  const [open, setOpen] = useState(false);
  const [files, setFiles] = useState([]);
  const [catalogType, setCatalogType] = useState("ACES");

  // ACES
  const [newItems, setNewItems] = useState([]);
  const [editedItems, setEditedItems] = useState([]);
  const [deletedItems, setDeletedItems] = useState([]);
  const [newRecords, setNewRecords] = useState(0);
  const [editedRecords, setEditedRecords] = useState(0);
  const [deletedRecords, setDeletedRecords] = useState(0);
  const [openAcesDialog, setOpenAcesDialog] = useState(false);

  // PIES
  const [piesNewItems, setPiesNewItems] = useState([]);
  const [piesEditedItems, setPiesEditedItems] = useState([]);
  const [piesDeletedItems, setPiesDeletedItems] = useState([]);
  const [piesNewRecords, setPiesNewRecords] = useState(0);
  const [piesEditedRecords, setPiesEditedRecords] = useState(0);
  const [piesDeletedRecords, setPiesDeletedRecords] = useState(0);
  const [openPiesDialog, setOpenPiesDialog] = useState(false);

  const handleOpen = () => setOpen(true);
  const handleClose = () => {
    setFiles([]);
    setOpen(false);
  };

  const handleFileSelect = (e) => {
    const selected = Array.from(e.target.files);
    const newFiles = selected.filter(
      (file) => !files.some((f) => f.name === file.name && f.size === file.size)
    );
    setFiles([...files, ...newFiles]);
  };

  const removeFile = (index) => {
    const newFiles = [...files];
    newFiles.splice(index, 1);
    setFiles(newFiles);
  };

  const uploadFiles = async () => {
    if (files.length === 0) {
      alert("Por favor, seleccione al menos un archivo para subir.");
      return;
    }

    // --- Lógica solo frontend para PIES ---
    if (catalogType === "PIES") {
      files.forEach((file) => {
        const reader = new FileReader();
        reader.onload = (event) => {
          const xmlText = event.target.result;
          const parser = new DOMParser();
          const xmlDoc = parser.parseFromString(xmlText, "text/xml");

          // ✅ Extraer todos los Items del XML PIES
          const items = Array.from(xmlDoc.getElementsByTagName("Item"));
          const parsedItems = items.map((node) => ({
            itemId: node.getElementsByTagName("ItemID")[0]?.textContent || null,
            partNumber: node.getElementsByTagName("PartNumber")[0]?.textContent || null,
            brandId: node.getElementsByTagName("BrandAAIAID")[0]?.textContent || null,
          }));

          // Aquí solo pintamos como "nuevos", pero puedes replicar la lógica si tienes editados/eliminados
          setPiesNewRecords(parsedItems.length);
          setPiesNewItems(parsedItems);
          setPiesEditedRecords(0);
          setPiesDeletedRecords(0);
          setPiesEditedItems([]);
          setPiesDeletedItems([]);
        };
        reader.readAsText(file);
      });

      alert("Archivo subido correctamente ");
      handleClose();
      return; // 👈 evitamos ir al backend
    }

    // --- Lógica normal para ACES (backend) ---
    const formData = new FormData();
    formData.append("catalogType", catalogType);
    files.forEach((file) => formData.append("files", file));

    try {
      const response = await axios.post("/upload", formData, {
        headers: { "Content-Type": "multipart/form-data" },
      });

      alert(`Archivos subidos correctamente: ${response.data.message || ""}`);

      if (response.data.summary) {
        const s = response.data.summary;
        setNewRecords(s.newRecords || 0);
        setEditedRecords(s.editedRecords || 0);
        setDeletedRecords(s.deletedRecords || 0);
        setNewItems(s.newItems || []);
        setEditedItems(s.editedItems || []);
        setDeletedItems(s.deletedItems || []);
      }

      handleClose();
    } catch (error) {
      console.error("Error al subir archivos:", error);
      alert("Ocurrió un error al subir los archivos. Intente de nuevo.");
    }
  };

  return (
    <Box sx={{ backgroundColor: "#f5f5f5", minHeight: "100vh" }}>
      <AppBar
        position="static"
        color="default"
        elevation={0}
        sx={{
          backgroundColor: "#fff",
          borderBottom: "1px solid #e0e0e0",
          paddingY: 1.5,
        }}
      >
        <Container
          sx={{
            display: "flex",
            justifyContent: "space-between",
            alignItems: "center",
          }}
        >
          <Box sx={{ display: "flex", alignItems: "center", gap: 2 }}>
            <img
              src="https://www.apymsa.com.mx/Content/Images/Logo-Apymsa-2024.png"
              alt="Logo APYMSA"
              style={{ height: 40 }}
            />
          </Box>

          <Button variant="contained" color="success" onClick={handleOpen}>
            Subir Catálogo
          </Button>
        </Container>
      </AppBar>

      {/* Contenido principal */}
      <Box className="main-content">
        <Container sx={{ mt: 4 }}>
          {/* REGISTROS NUEVOS */}
          <Card sx={{ mb: 3 }}>
            <CardContent>
              <Typography className="section-title">
                REGISTROS NUEVOS
              </Typography>
              <Accordion>
                <AccordionSummary expandIcon={<ExpandMoreIcon />}>
                  <Typography>ACES ({newRecords})</Typography>
                </AccordionSummary>
                <AccordionDetails>
                  <List>
                    {newItems.slice(0, 10).map((item, idx) => (
                      <ListItem key={idx}>
                        <ListItemText
                          primary={`Parte: ${item.partNumber || "N/A"}`}
                          secondary={`BaseVehicleId: ${
                            item.baseVehicleId || "-"
                          }`}
                        />
                      </ListItem>
                    ))}
                  </List>

                  {newItems.length > 10 && (
                    <Button
                      onClick={() => setOpenAcesDialog(true)}
                      sx={{ mt: 2 }}
                    >
                      Ver más ({newItems.length - 10} restantes)
                    </Button>
                  )}
                </AccordionDetails>
              </Accordion>

              <Accordion>
                <AccordionSummary expandIcon={<ExpandMoreIcon />}>
                  <Typography>PIES ({piesNewRecords})</Typography>
                </AccordionSummary>
                <AccordionDetails>
                  <List>
                    {piesNewItems.slice(0, 10).map((item, idx) => (
                      <ListItem key={idx}>
                       <ListItemText
                          primary={`Parte: ${item.partNumber || "N/A"}`}
                          secondary={`ID: ${item.itemId || "-"} | Marca: ${item.brandId || "-"}`}
                        />
                      </ListItem>
                    ))}
                  </List>

                  {piesNewItems.length > 10 && (
                    <Button
                      onClick={() => setOpenPiesDialog(true)}
                      sx={{ mt: 2 }}
                    >
                      Ver más ({piesNewItems.length - 10} restantes)
                    </Button>
                  )}
                </AccordionDetails>
              </Accordion>
            </CardContent>
          </Card>

          {/* REGISTROS EDITADOS */}
          <Card sx={{ mb: 3 }}>
            <CardContent>
              <Typography className="section-title">
                REGISTROS EDITADOS
              </Typography>
              <Accordion>
                <AccordionSummary expandIcon={<ExpandMoreIcon />}>
                  <Typography>ACES ({editedRecords})</Typography>
                </AccordionSummary>
                <AccordionDetails>
                  <List>
                    {editedItems.map((item, idx) => (
                      <ListItem key={idx}>
                        <ListItemText
                          primary={`Parte: ${item.partNumber || "N/A"}`}
                          secondary={`BaseVehicleId: ${
                            item.baseVehicleId || "-"
                          }`}
                        />
                      </ListItem>
                    ))}
                  </List>
                </AccordionDetails>
              </Accordion>

              <Accordion>
                <AccordionSummary expandIcon={<ExpandMoreIcon />}>
                  <Typography>PIES ({piesEditedRecords})</Typography>
                </AccordionSummary>
                <AccordionDetails>
                  <List>
                    {piesEditedItems.map((item, idx) => (
                      <ListItem key={idx}>
                        <ListItemText
                          primary={`Parte: ${item.partNumber || "N/A"}`}
                          secondary={`Descripción: ${item.description || "-"}`}
                        />
                      </ListItem>
                    ))}
                  </List>
                </AccordionDetails>
              </Accordion>
            </CardContent>
          </Card>

          {/* REGISTROS ELIMINADOS */}
          <Card sx={{ mb: 3 }}>
            <CardContent>
              <Typography className="section-title">
                REGISTROS ELIMINADOS
              </Typography>
              <Accordion>
                <AccordionSummary expandIcon={<ExpandMoreIcon />}>
                  <Typography>ACES ({deletedRecords})</Typography>
                </AccordionSummary>
                <AccordionDetails>
                  <List>
                    {deletedItems.map((item, idx) => (
                      <ListItem key={idx}>
                        <ListItemText
                          primary={`Parte: ${item.partNumber || "N/A"}`}
                          secondary={`BaseVehicleId: ${
                            item.baseVehicleId || "-"
                          }`}
                        />
                      </ListItem>
                    ))}
                  </List>
                </AccordionDetails>
              </Accordion>

              <Accordion>
                <AccordionSummary expandIcon={<ExpandMoreIcon />}>
                  <Typography>PIES ({piesDeletedRecords})</Typography>
                </AccordionSummary>
                <AccordionDetails>
                  <List>
                    {piesDeletedItems.map((item, idx) => (
                      <ListItem key={idx}>
                        <ListItemText
                          primary={`Parte: ${item.partNumber || "N/A"}`}
                          secondary={`Descripción: ${item.description || "-"}`}
                        />
                      </ListItem>
                    ))}
                  </List>
                </AccordionDetails>
              </Accordion>
            </CardContent>
          </Card>
        </Container>

        {/* DIALOG */}
        <Dialog open={open} onClose={handleClose} fullWidth maxWidth="sm">
          <DialogTitle>
            Subir Catálogo
            <IconButton
              aria-label="close"
              onClick={handleClose}
              sx={{ position: "absolute", right: 8, top: 8 }}
            >
              <CloseIcon />
            </IconButton>
          </DialogTitle>
          <DialogContent dividers>
            <select
              value={catalogType}
              onChange={(e) => setCatalogType(e.target.value)}
              style={{ marginBottom: "1rem", padding: "0.5rem", width: "100%" }}
            >
              <option value="ACES">ACES</option>
              <option value="PIES">PIES</option>
            </select>

            <Paper
              variant="outlined"
              sx={{
                borderStyle: "dashed",
                p: 4,
                textAlign: "center",
                cursor: "pointer",
                mb: 2,
              }}
              onClick={() => document.getElementById("fileInput").click()}
            >
              <CloudUploadIcon sx={{ fontSize: 48, color: "gray" }} />
              <Typography>
                Arrastre o seleccione los archivos correspondientes
              </Typography>
              <Button variant="contained" sx={{ mt: 2 }}>
                Seleccionar archivos
              </Button>
              <input
                id="fileInput"
                type="file"
                accept=".aces,.pies,.xml,.txt"
                multiple
                hidden
                onChange={handleFileSelect}
              />
            </Paper>

            {files.length > 0 && (
              <List>
                {files.map((file, index) => (
                  <ListItem
                    key={index}
                    secondaryAction={
                      <IconButton edge="end" onClick={() => removeFile(index)}>
                        <DeleteIcon color="error" />
                      </IconButton>
                    }
                  >
                    <ListItemText
                      primary={file.name}
                      secondary={formatFileSize(file.size)}
                    />
                  </ListItem>
                ))}
              </List>
            )}
          </DialogContent>
          <DialogActions>
            <Button onClick={handleClose} color="error">
              Cancelar
            </Button>
            <Button onClick={uploadFiles} variant="contained">
              Subir
            </Button>
          </DialogActions>
        </Dialog>
      </Box>
      <Dialog
        open={openPiesDialog}
        onClose={() => setOpenPiesDialog(false)}
        fullWidth
        maxWidth="md"
      >
        <DialogTitle>
          Todos los registros nuevos de PIES
          <IconButton
            aria-label="close"
            onClick={() => setOpenPiesDialog(false)}
            sx={{ position: "absolute", right: 8, top: 8 }}
          >
            <CloseIcon />
          </IconButton>
        </DialogTitle>
        <DialogContent dividers sx={{ maxHeight: "70vh" }}>
          <List>
            {piesNewItems.map((item, idx) => (
              <ListItem key={idx}>
                <ListItemText
                  primary={`Parte: ${item.partNumber || "N/A"}`}
                  secondary={`Descripción: ${item.description || "-"}`}
                />
              </ListItem>
            ))}
          </List>
        </DialogContent>
        <DialogActions>
          <Button onClick={() => setOpenPiesDialog(false)} color="primary">
            Cerrar
          </Button>
        </DialogActions>
      </Dialog>
      <Dialog
  open={openAcesDialog}
  onClose={() => setOpenAcesDialog(false)}
  fullWidth
  maxWidth="md"
>
  <DialogTitle>
    Todos los registros nuevos de ACES
    <IconButton
      aria-label="close"
      onClick={() => setOpenAcesDialog(false)}
      sx={{ position: "absolute", right: 8, top: 8 }}
    >
      <CloseIcon />
    </IconButton>
  </DialogTitle>
  <DialogContent dividers sx={{ maxHeight: "70vh" }}>
    <List>
      {newItems.map((item, idx) => (
        <ListItem key={idx}>
          <ListItemText
            primary={`Parte: ${item.partNumber || "N/A"}`}
            secondary={`BaseVehicleId: ${item.baseVehicleId || "-"}`}
          />
        </ListItem>
      ))}
    </List>
  </DialogContent>
  <DialogActions>
    <Button onClick={() => setOpenAcesDialog(false)} color="primary">
      Cerrar
    </Button>
  </DialogActions>
</Dialog>


      {/* FOOTER */}
      <Box className="footer" sx={{ mt: 4 }}>
        <Container>
          <Grid container spacing={4}>
            <Grid item xs={12} md={4}>
              <Typography variant="h6" gutterBottom>
                Quienes somos
              </Typography>
              <ul>
                <li>Responsabilidad Social</li>
                <li>Solicitud de crédito</li>
                <li>Descarga de códigos SAT</li>
              </ul>
            </Grid>
            <Grid item xs={12} md={4}>
              <Typography variant="h6" gutterBottom>
                Datos de Contacto
              </Typography>
              <ul>
                <li>Lorem ipsum dolor sit amet</li>
                <li>sed do eiusmod tempor incididunt</li>
                <li>Ut enim ad minim veniam</li>
              </ul>
            </Grid>
            <Grid item xs={12} md={4}>
              <Typography variant="h6" gutterBottom>
                Contáctanos
              </Typography>
              <Stack direction="row" spacing={2} className="footer-icons">
                <Link
                  href="https://www.youtube.com/@APYMSA.oficial"
                  target="_blank"
                  rel="noopener"
                >
                  <YouTubeIcon />
                </Link>
                <Link
                  href="https://www.facebook.com/Apymsa.Oficial/"
                  target="_blank"
                  rel="noopener"
                >
                  <FacebookIcon />
                </Link>
                <Link
                  href="https://api.whatsapp.com/send/?phone=523316026164&text&type=phone_number&app_absent=0"
                  target="_blank"
                  rel="noopener"
                >
                  <WhatsAppIcon />
                </Link>
                <Link
                  href="https://www.instagram.com/refaccionariaapymsa.oficial/?hl=es"
                  target="_blank"
                  rel="noopener"
                >
                  <InstagramIcon />
                </Link>
              </Stack>
            </Grid>
          </Grid>
        </Container>
      </Box>
    </Box>
  );
};
//add a button to change the theme
export default App;
