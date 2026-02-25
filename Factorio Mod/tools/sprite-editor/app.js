const EDITOR_PIXEL_SCALE = 8;

const MODE = {
  ITEM: "item",
  BUILDING: "building",
  BUILDING_LARGE: "building-large"
};

const MODE_CONFIG = {
  [MODE.ITEM]: {
    spriteSize: 64,
    hint: "Linksklick: malen · Im Pipettenmodus: Farbe aufnehmen · Rechtsklick: Pipette",
    importLabel: "PNG importieren (64x64)"
  },
  [MODE.BUILDING]: {
    spriteSize: 96,
    hint: "Gebäude-Modus 96x96 · Linksklick: malen · Pipette zum Farbauflösen",
    importLabel: "PNG importieren (96x96)"
  },
  [MODE.BUILDING_LARGE]: {
    spriteSize: 400,
    hint: "Gebäude-Modus 400x400 · Linksklick: malen · Pipette zum Farbauflösen",
    importLabel: "PNG importieren (400x400)"
  }
};

const BASE_BUILDING_LAYOUT = {
  original: { width: 1712, height: 904, columns: 8, rows: 4 },
  shadow: { width: 1520, height: 660, columns: 8, rows: 4 },
  remants: { width: 328, height: 846, columns: 1, rows: 3 }
};

const editorCanvas = document.getElementById("editorCanvas");
const editorCtx = editorCanvas.getContext("2d", { willReadFrequently: true });
const editorHint = document.getElementById("editorHint");

const preview64 = document.getElementById("preview64");
const preview32 = document.getElementById("preview32");
const preview16 = document.getElementById("preview16");
const preview8 = document.getElementById("preview8");
const sheetPreview = document.getElementById("sheetPreview");

const buildingPreviewCanvas = document.getElementById("buildingPreview96");
const buildingSheetOriginalPreview = document.getElementById("buildingSheetOriginalPreview");
const buildingSheetShadowPreview = document.getElementById("buildingSheetShadowPreview");
const buildingSheetRemantsPreview = document.getElementById("buildingSheetRemantsPreview");

const buildingPreviewTitle = document.getElementById("buildingPreviewTitle");
const buildingOriginalTitle = document.getElementById("buildingOriginalTitle");
const buildingShadowTitle = document.getElementById("buildingShadowTitle");
const buildingRemantsTitle = document.getElementById("buildingRemantsTitle");

const itemOutputBlock = document.getElementById("itemOutputBlock");
const buildingOutputBlock = document.getElementById("buildingOutputBlock");
const buildingNameGroup = document.getElementById("buildingNameGroup");

const colorInput = document.getElementById("colorInput");
const colorValue = document.getElementById("colorValue");
const drawTool = document.getElementById("drawTool");
const pickTool = document.getElementById("pickTool");
const clearBtn = document.getElementById("clearBtn");
const modeItemBtn = document.getElementById("modeItemBtn");
const modeBuildingBtn = document.getElementById("modeBuildingBtn");
const modeBuildingLargeBtn = document.getElementById("modeBuildingLargeBtn");

const exportItemBtn = document.getElementById("exportItemBtn");
const exportBuildingBtn = document.getElementById("exportBuildingBtn");
const importPngBtn = document.getElementById("importPngBtn");
const saveBtn = document.getElementById("saveBtn");
const loadBtn = document.getElementById("loadBtn");
const importPngInput = document.getElementById("importPngInput");
const loadInput = document.getElementById("loadInput");
const buildingBaseName = document.getElementById("buildingBaseName");
const paletteRoot = document.getElementById("palette");

let activeMode = MODE.ITEM;
let activeTool = "draw";
let isDrawing = false;

const spriteCanvas = document.createElement("canvas");
const spriteCtx = spriteCanvas.getContext("2d", { willReadFrequently: true });

const item32 = document.createElement("canvas");
item32.width = 32;
item32.height = 32;
const item32Ctx = item32.getContext("2d");

const item16 = document.createElement("canvas");
item16.width = 16;
item16.height = 16;
const item16Ctx = item16.getContext("2d");

const item8 = document.createElement("canvas");
item8.width = 8;
item8.height = 8;
const item8Ctx = item8.getContext("2d");

const itemSheet = document.createElement("canvas");
itemSheet.width = 120;
itemSheet.height = 64;
const itemSheetCtx = itemSheet.getContext("2d");

const buildingOriginalSheet = document.createElement("canvas");
const buildingOriginalSheetCtx = buildingOriginalSheet.getContext("2d");
const buildingShadowSheet = document.createElement("canvas");
const buildingShadowSheetCtx = buildingShadowSheet.getContext("2d");
const buildingRemantsSheet = document.createElement("canvas");
const buildingRemantsSheetCtx = buildingRemantsSheet.getContext("2d");

const defaultPalette = [
  "#000000",
  "#ffffff",
  "#c79a66",
  "#8b5a2b",
  "#d9b38c",
  "#4f4f4f",
  "#7f7f7f",
  "#b6b6b6",
  "#8f3f2a",
  "#3f7f5f",
  "#3f5f8f",
  "#d0af00"
];

function setImageRendering(context) {
  context.imageSmoothingEnabled = false;
}

function getCurrentSpriteSize() {
  return MODE_CONFIG[activeMode].spriteSize;
}

function isBuildingMode(mode = activeMode) {
  return mode === MODE.BUILDING || mode === MODE.BUILDING_LARGE;
}

function getBuildingSheetLayout() {
  if (activeMode === MODE.BUILDING_LARGE) {
    const spriteSize = MODE_CONFIG[MODE.BUILDING_LARGE].spriteSize;
    return {
      original: {
        width: spriteSize * 8,
        height: spriteSize * 4,
        columns: 8,
        rows: 4
      },
      shadow: {
        width: (spriteSize + 2) * 8,
        height: (spriteSize + 4) * 4,
        columns: 8,
        rows: 4
      },
      remants: {
        width: spriteSize,
        height: spriteSize * 3,
        columns: 1,
        rows: 3
      }
    };
  }

  const spriteSize = getCurrentSpriteSize();
  const scale = spriteSize / 96;

  return {
    original: {
      width: Math.round(BASE_BUILDING_LAYOUT.original.width * scale),
      height: Math.round(BASE_BUILDING_LAYOUT.original.height * scale),
      columns: BASE_BUILDING_LAYOUT.original.columns,
      rows: BASE_BUILDING_LAYOUT.original.rows
    },
    shadow: {
      width: Math.round(BASE_BUILDING_LAYOUT.shadow.width * scale),
      height: Math.round(BASE_BUILDING_LAYOUT.shadow.height * scale),
      columns: BASE_BUILDING_LAYOUT.shadow.columns,
      rows: BASE_BUILDING_LAYOUT.shadow.rows
    },
    remants: {
      width: Math.round(BASE_BUILDING_LAYOUT.remants.width * scale),
      height: Math.round(BASE_BUILDING_LAYOUT.remants.height * scale),
      columns: BASE_BUILDING_LAYOUT.remants.columns,
      rows: BASE_BUILDING_LAYOUT.remants.rows
    }
  };
}

function resizeCanvas(canvas, width, height) {
  canvas.width = width;
  canvas.height = height;
}

function updateBuildingPreviewLayout() {
  if (!isBuildingMode()) {
    return;
  }

  const spriteSize = getCurrentSpriteSize();
  const layout = getBuildingSheetLayout();

  resizeCanvas(buildingPreviewCanvas, spriteSize, spriteSize);
  resizeCanvas(buildingSheetOriginalPreview, layout.original.width, layout.original.height);
  resizeCanvas(buildingSheetShadowPreview, layout.shadow.width, layout.shadow.height);
  resizeCanvas(buildingSheetRemantsPreview, layout.remants.width, layout.remants.height);

  resizeCanvas(buildingOriginalSheet, layout.original.width, layout.original.height);
  resizeCanvas(buildingShadowSheet, layout.shadow.width, layout.shadow.height);
  resizeCanvas(buildingRemantsSheet, layout.remants.width, layout.remants.height);

  [
    buildingPreviewCanvas.getContext("2d"),
    buildingSheetOriginalPreview.getContext("2d"),
    buildingSheetShadowPreview.getContext("2d"),
    buildingSheetRemantsPreview.getContext("2d"),
    buildingOriginalSheetCtx,
    buildingShadowSheetCtx,
    buildingRemantsSheetCtx
  ].forEach(setImageRendering);

  buildingPreviewTitle.textContent = `Gebäude ${spriteSize}x${spriteSize}`;
  buildingOriginalTitle.textContent = `originalname.png (${layout.original.width}x${layout.original.height}, 8x4)`;
  buildingShadowTitle.textContent = `originalname-shadow.png (${layout.shadow.width}x${layout.shadow.height}, 8x4)`;
  buildingRemantsTitle.textContent = `remants/originalname-remants.png (${layout.remants.width}x${layout.remants.height}, 1x3)`;
}

function init() {
  [
    editorCtx,
    spriteCtx,
    item32Ctx,
    item16Ctx,
    item8Ctx,
    itemSheetCtx,
    buildingOriginalSheetCtx,
    buildingShadowSheetCtx,
    buildingRemantsSheetCtx,
    preview64.getContext("2d"),
    preview32.getContext("2d"),
    preview16.getContext("2d"),
    preview8.getContext("2d"),
    sheetPreview.getContext("2d"),
    buildingPreviewCanvas.getContext("2d"),
    buildingSheetOriginalPreview.getContext("2d"),
    buildingSheetShadowPreview.getContext("2d"),
    buildingSheetRemantsPreview.getContext("2d")
  ].forEach(setImageRendering);

  buildPalette();
  bindEvents();
  setMode(MODE.ITEM);
  clearSprite();
  render();
}

function bindEvents() {
  editorCanvas.addEventListener("mousedown", (event) => {
    isDrawing = true;
    handlePaintOrPick(event);
  });

  editorCanvas.addEventListener("mousemove", (event) => {
    if (!isDrawing || activeTool !== "draw") {
      return;
    }

    handlePaintOrPick(event);
  });

  window.addEventListener("mouseup", () => {
    isDrawing = false;
  });

  editorCanvas.addEventListener("contextmenu", (event) => {
    event.preventDefault();
    const pixel = getPixelFromEvent(event);
    if (!pixel) {
      return;
    }
    pickColor(pixel.x, pixel.y);
  });

  drawTool.addEventListener("click", () => setTool("draw"));
  pickTool.addEventListener("click", () => setTool("pick"));

  modeItemBtn.addEventListener("click", () => setMode(MODE.ITEM));
  modeBuildingBtn.addEventListener("click", () => setMode(MODE.BUILDING));
  modeBuildingLargeBtn.addEventListener("click", () => setMode(MODE.BUILDING_LARGE));

  colorInput.addEventListener("input", () => {
    colorValue.textContent = colorInput.value.toUpperCase();
  });

  clearBtn.addEventListener("click", () => {
    clearSprite();
    render();
  });

  exportItemBtn.addEventListener("click", exportItemSheetPng);
  exportBuildingBtn.addEventListener("click", exportBuildingFiles);
  importPngBtn.addEventListener("click", () => importPngInput.click());
  importPngInput.addEventListener("change", importPngFile);

  saveBtn.addEventListener("click", saveProjectJson);
  loadBtn.addEventListener("click", () => loadInput.click());
  loadInput.addEventListener("change", loadProjectJson);
}

function buildPalette() {
  paletteRoot.innerHTML = "";

  for (const color of defaultPalette) {
    const swatch = document.createElement("button");
    swatch.type = "button";
    swatch.style.background = color;
    swatch.title = color;
    swatch.addEventListener("click", () => setCurrentColor(color));
    paletteRoot.appendChild(swatch);
  }
}

function setCurrentColor(hex) {
  colorInput.value = hex;
  colorValue.textContent = hex.toUpperCase();
}

function setTool(tool) {
  activeTool = tool;
  drawTool.classList.toggle("active", tool === "draw");
  pickTool.classList.toggle("active", tool === "pick");
}

function setMode(mode) {
  activeMode = mode;

  modeItemBtn.classList.toggle("active", mode === MODE.ITEM);
  modeBuildingBtn.classList.toggle("active", mode === MODE.BUILDING);
  modeBuildingLargeBtn.classList.toggle("active", mode === MODE.BUILDING_LARGE);

  const spriteSize = getCurrentSpriteSize();
  spriteCanvas.width = spriteSize;
  spriteCanvas.height = spriteSize;

  const editorSize = spriteSize * EDITOR_PIXEL_SCALE;
  editorCanvas.width = editorSize;
  editorCanvas.height = editorSize;

  editorHint.textContent = MODE_CONFIG[mode].hint;
  importPngBtn.textContent = MODE_CONFIG[mode].importLabel;

  itemOutputBlock.classList.toggle("hidden", mode !== MODE.ITEM);
  const buildingActive = isBuildingMode(mode);
  buildingOutputBlock.classList.toggle("hidden", !buildingActive);
  buildingNameGroup.classList.toggle("hidden", !buildingActive);
  exportItemBtn.classList.toggle("hidden", mode !== MODE.ITEM);
  exportBuildingBtn.classList.toggle("hidden", !buildingActive);

  if (buildingActive) {
    updateBuildingPreviewLayout();
  }

  clearSprite();
  render();
}

function clearSprite() {
  const spriteSize = getCurrentSpriteSize();
  spriteCtx.clearRect(0, 0, spriteSize, spriteSize);
}

function getPixelFromEvent(event) {
  const spriteSize = getCurrentSpriteSize();
  const rect = editorCanvas.getBoundingClientRect();
  const px = Math.floor((event.clientX - rect.left) / EDITOR_PIXEL_SCALE);
  const py = Math.floor((event.clientY - rect.top) / EDITOR_PIXEL_SCALE);

  if (px < 0 || py < 0 || px >= spriteSize || py >= spriteSize) {
    return null;
  }

  return { x: px, y: py };
}

function handlePaintOrPick(event) {
  const pixel = getPixelFromEvent(event);
  if (!pixel) {
    return;
  }

  if (activeTool === "pick") {
    pickColor(pixel.x, pixel.y);
    return;
  }

  paintPixel(pixel.x, pixel.y, colorInput.value);
  render();
}

function paintPixel(x, y, hex) {
  spriteCtx.fillStyle = hex;
  spriteCtx.fillRect(x, y, 1, 1);
}

function pickColor(x, y) {
  const pixel = spriteCtx.getImageData(x, y, 1, 1).data;
  const hex = rgbToHex(pixel[0], pixel[1], pixel[2]);
  setCurrentColor(hex);
}

function rgbToHex(r, g, b) {
  return "#" + [r, g, b].map((value) => value.toString(16).padStart(2, "0")).join("");
}

function drawEditorGrid() {
  const spriteSize = getCurrentSpriteSize();
  const editorSize = spriteSize * EDITOR_PIXEL_SCALE;

  editorCtx.clearRect(0, 0, editorSize, editorSize);
  editorCtx.drawImage(spriteCanvas, 0, 0, spriteSize, spriteSize, 0, 0, editorSize, editorSize);

  editorCtx.strokeStyle = "rgba(255,255,255,0.12)";
  editorCtx.lineWidth = 1;

  for (let i = 0; i <= spriteSize; i++) {
    const pos = i * EDITOR_PIXEL_SCALE + 0.5;

    editorCtx.beginPath();
    editorCtx.moveTo(pos, 0);
    editorCtx.lineTo(pos, editorSize);
    editorCtx.stroke();

    editorCtx.beginPath();
    editorCtx.moveTo(0, pos);
    editorCtx.lineTo(editorSize, pos);
    editorCtx.stroke();
  }
}

function drawPreview(targetCanvas, sourceCanvas) {
  const context = targetCanvas.getContext("2d");
  setImageRendering(context);
  context.clearRect(0, 0, targetCanvas.width, targetCanvas.height);
  context.drawImage(sourceCanvas, 0, 0, sourceCanvas.width, sourceCanvas.height, 0, 0, targetCanvas.width, targetCanvas.height);
}

function renderItemOutputs() {
  item32Ctx.clearRect(0, 0, 32, 32);
  item16Ctx.clearRect(0, 0, 16, 16);
  item8Ctx.clearRect(0, 0, 8, 8);

  item32Ctx.drawImage(spriteCanvas, 0, 0, spriteCanvas.width, spriteCanvas.height, 0, 0, 32, 32);
  item16Ctx.drawImage(spriteCanvas, 0, 0, spriteCanvas.width, spriteCanvas.height, 0, 0, 16, 16);
  item8Ctx.drawImage(spriteCanvas, 0, 0, spriteCanvas.width, spriteCanvas.height, 0, 0, 8, 8);

  itemSheetCtx.clearRect(0, 0, 120, 64);
  itemSheetCtx.drawImage(spriteCanvas, 0, 0, 64, 64);
  itemSheetCtx.drawImage(item32, 64, 0);
  itemSheetCtx.drawImage(item16, 96, 0);
  itemSheetCtx.drawImage(item8, 112, 0);

  drawPreview(preview64, spriteCanvas);
  drawPreview(preview32, item32);
  drawPreview(preview16, item16);
  drawPreview(preview8, item8);
  drawPreview(sheetPreview, itemSheet);
}

function drawSpriteGridSheet(sourceCanvas, targetCanvas, columns, rows) {
  const context = targetCanvas.getContext("2d");
  setImageRendering(context);
  context.clearRect(0, 0, targetCanvas.width, targetCanvas.height);

  const cellWidth = targetCanvas.width / columns;
  const cellHeight = targetCanvas.height / rows;
  const scale = Math.max(1, Math.floor(Math.min(cellWidth / sourceCanvas.width, cellHeight / sourceCanvas.height)));
  const drawWidth = sourceCanvas.width * scale;
  const drawHeight = sourceCanvas.height * scale;

  for (let row = 0; row < rows; row++) {
    for (let column = 0; column < columns; column++) {
      const cellX = column * cellWidth;
      const cellY = row * cellHeight;
      const drawX = Math.floor(cellX + (cellWidth - drawWidth) / 2);
      const drawY = Math.floor(cellY + (cellHeight - drawHeight) / 2);
      context.drawImage(sourceCanvas, 0, 0, sourceCanvas.width, sourceCanvas.height, drawX, drawY, drawWidth, drawHeight);
    }
  }
}

function createShadowCanvas(sourceCanvas) {
  const shadowCanvas = document.createElement("canvas");
  shadowCanvas.width = sourceCanvas.width + 2;
  shadowCanvas.height = sourceCanvas.height + 4;

  const shadowCtx = shadowCanvas.getContext("2d", { willReadFrequently: true });
  setImageRendering(shadowCtx);

  const sourceData = spriteCtx.getImageData(0, 0, sourceCanvas.width, sourceCanvas.height);
  const shadowData = shadowCtx.createImageData(shadowCanvas.width, shadowCanvas.height);

  for (let y = 0; y < sourceCanvas.height; y++) {
    for (let x = 0; x < sourceCanvas.width; x++) {
      const sourceIndex = (y * sourceCanvas.width + x) * 4;
      const alpha = sourceData.data[sourceIndex + 3];
      if (alpha === 0) {
        continue;
      }

      const targetX = x + 2;
      const targetY = y + 4;
      const targetIndex = (targetY * shadowCanvas.width + targetX) * 4;

      shadowData.data[targetIndex] = 0;
      shadowData.data[targetIndex + 1] = 0;
      shadowData.data[targetIndex + 2] = 0;
      shadowData.data[targetIndex + 3] = alpha;
    }
  }

  shadowCtx.putImageData(shadowData, 0, 0);
  return shadowCanvas;
}

function renderBuildingOutputs() {
  const layout = getBuildingSheetLayout();

  drawSpriteGridSheet(spriteCanvas, buildingOriginalSheet, layout.original.columns, layout.original.rows);
  const shadowCanvas = createShadowCanvas(spriteCanvas);
  drawSpriteGridSheet(shadowCanvas, buildingShadowSheet, layout.shadow.columns, layout.shadow.rows);
  drawSpriteGridSheet(spriteCanvas, buildingRemantsSheet, layout.remants.columns, layout.remants.rows);

  drawPreview(buildingPreviewCanvas, spriteCanvas);
  drawPreview(buildingSheetOriginalPreview, buildingOriginalSheet);
  drawPreview(buildingSheetShadowPreview, buildingShadowSheet);
  drawPreview(buildingSheetRemantsPreview, buildingRemantsSheet);
}

function render() {
  drawEditorGrid();

  if (activeMode === MODE.ITEM) {
    renderItemOutputs();
    return;
  }

  renderBuildingOutputs();
}

function exportItemSheetPng() {
  if (activeMode !== MODE.ITEM) {
    return;
  }

  downloadCanvas(itemSheet, "sprite_120x64.png");
}

function sanitizeBaseName(name) {
  const clean = name.trim().replace(/[^a-zA-Z0-9_-]/g, "_");
  return clean || "building";
}

function downloadCanvas(canvas, fileName) {
  const link = document.createElement("a");
  link.href = canvas.toDataURL("image/png");
  link.download = fileName;
  link.click();
}

async function writeFileToDirectory(directoryHandle, fileName, blob) {
  const fileHandle = await directoryHandle.getFileHandle(fileName, { create: true });
  const writable = await fileHandle.createWritable();
  await writable.write(blob);
  await writable.close();
}

async function exportBuildingFiles() {
  if (!isBuildingMode()) {
    return;
  }

  renderBuildingOutputs();

  const baseName = sanitizeBaseName(buildingBaseName.value);
  const originalName = `${baseName}.png`;
  const shadowName = `${baseName}-shadow.png`;
  const remantsName = `${baseName}-remants.png`;

  const originalBlob = await canvasToBlob(buildingOriginalSheet);
  const shadowBlob = await canvasToBlob(buildingShadowSheet);
  const remantsBlob = await canvasToBlob(buildingRemantsSheet);

  if (typeof window.showDirectoryPicker === "function") {
    try {
      const directoryHandle = await window.showDirectoryPicker();
      await writeFileToDirectory(directoryHandle, originalName, originalBlob);
      await writeFileToDirectory(directoryHandle, shadowName, shadowBlob);
      const remantsDir = await directoryHandle.getDirectoryHandle("remants", { create: true });
      await writeFileToDirectory(remantsDir, remantsName, remantsBlob);
      alert("Gebäude-Dateien wurden exportiert.");
      return;
    } catch (error) {
      if (error && error.name === "AbortError") {
        return;
      }
    }
  }

  downloadBlob(originalBlob, originalName);
  downloadBlob(shadowBlob, shadowName);
  downloadBlob(remantsBlob, `remants_${remantsName}`);
  alert("Browser-Fallback: remants-Datei wurde als remants_<name>-remants.png gespeichert. Bitte manuell in den Ordner remants verschieben.");
}

function canvasToBlob(canvas) {
  return new Promise((resolve, reject) => {
    canvas.toBlob((blob) => {
      if (!blob) {
        reject(new Error("Blob konnte nicht erstellt werden"));
        return;
      }
      resolve(blob);
    }, "image/png");
  });
}

function downloadBlob(blob, fileName) {
  const url = URL.createObjectURL(blob);
  const link = document.createElement("a");
  link.href = url;
  link.download = fileName;
  link.click();
  URL.revokeObjectURL(url);
}

function importPngFile(event) {
  const file = event.target.files?.[0];
  if (!file) {
    return;
  }

  const expectedSize = getCurrentSpriteSize();
  const imageUrl = URL.createObjectURL(file);
  const image = new Image();

  image.onload = () => {
    try {
      if (image.width !== expectedSize || image.height !== expectedSize) {
        alert(`Bitte ein PNG mit exakt ${expectedSize}x${expectedSize} Pixeln wählen.`);
        return;
      }

      clearSprite();
      spriteCtx.drawImage(image, 0, 0, expectedSize, expectedSize);
      render();
    } finally {
      URL.revokeObjectURL(imageUrl);
      event.target.value = "";
    }
  };

  image.onerror = () => {
    URL.revokeObjectURL(imageUrl);
    event.target.value = "";
    alert("PNG konnte nicht geladen werden.");
  };

  image.src = imageUrl;
}

function saveProjectJson() {
  const size = getCurrentSpriteSize();
  const data = spriteCtx.getImageData(0, 0, size, size).data;

  const payload = {
    version: 2,
    mode: activeMode,
    width: size,
    height: size,
    rgba: Array.from(data)
  };

  const blob = new Blob([JSON.stringify(payload)], { type: "application/json" });
  const url = URL.createObjectURL(blob);
  const link = document.createElement("a");
  link.href = url;
  link.download = "sprite-project.json";
  link.click();
  URL.revokeObjectURL(url);
}

function loadProjectJson(event) {
  const file = event.target.files?.[0];
  if (!file) {
    return;
  }

  const reader = new FileReader();
  reader.onload = () => {
    try {
      const payload = JSON.parse(String(reader.result));
      if (!Array.isArray(payload.rgba) || !payload.width || !payload.height) {
        throw new Error("Ungültige Projektdatei");
      }

      if (payload.width === 64 && payload.height === 64) {
        setMode(MODE.ITEM);
      } else if (payload.width === 96 && payload.height === 96) {
        setMode(MODE.BUILDING);
      } else if (payload.width === 400 && payload.height === 400) {
        setMode(MODE.BUILDING_LARGE);
      } else {
        throw new Error("Nur 64x64, 96x96 oder 400x400 werden unterstützt");
      }

      const expectedLength = payload.width * payload.height * 4;
      if (payload.rgba.length !== expectedLength) {
        throw new Error("Ungültige Farbdaten");
      }

      const imageData = spriteCtx.createImageData(payload.width, payload.height);
      imageData.data.set(payload.rgba);
      spriteCtx.putImageData(imageData, 0, 0);
      render();
    } catch (error) {
      alert("Projekt konnte nicht geladen werden.");
    }
  };

  reader.readAsText(file);
  event.target.value = "";
}

init();
