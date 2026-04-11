import { NodeCompiler } from "@myriaddreamin/typst-ts-node-compiler";
import fs from "node:fs";
import path from "node:path";
import { fileURLToPath } from "node:url";

const __dirname = path.dirname(fileURLToPath(import.meta.url));
const ROOT = path.resolve(__dirname, "..");
const SPEC_DIR = path.resolve(ROOT, "src/content/spec");
const INPUT = path.join(SPEC_DIR, "resume.typ");
const OUT_DIR = path.resolve(ROOT, "public/resume");

// Ensure output directory
fs.mkdirSync(OUT_DIR, { recursive: true });

// Clean old artifacts
for (const f of fs.readdirSync(OUT_DIR)) {
	fs.rmSync(path.join(OUT_DIR, f));
}

if (!fs.existsSync(INPUT)) {
	console.warn("[compile-typst] resume.typ not found, skipping.");
	process.exit(0);
}

console.log("[compile-typst] Compiling", INPUT);

const compiler = NodeCompiler.create({ workspace: SPEC_DIR });

let pdfBuf, svgStr;
try {
	pdfBuf = compiler.pdf({ mainFilePath: INPUT });
	svgStr = compiler.svg({ mainFilePath: INPUT });
} catch (e) {
	const msg = e?.code || e?.message || String(e);
	console.error("[compile-typst] Compilation failed:", msg);
	if (msg.includes("file not found")) {
		console.error("[compile-typst] A template or dependency is missing. Check that all #import paths exist.");
	}
	process.exit(1);
}

// Write PDF
fs.writeFileSync(path.join(OUT_DIR, "resume.pdf"), pdfBuf);
console.log("[compile-typst] PDF written (%d KB)", Math.round(pdfBuf.length / 1024));

// Write SVG (all pages stacked vertically in one SVG)
fs.writeFileSync(path.join(OUT_DIR, "resume.svg"), svgStr);
console.log("[compile-typst] SVG written (%d KB)", Math.round(svgStr.length / 1024));

// Parse viewBox to determine page dimensions
// viewBox format: "0 0 <width> <totalHeight>"
// Each page is A4-ish, pages stacked vertically
const viewBoxMatch = svgStr.match(/viewBox="([^"]+)"/);
if (!viewBoxMatch) {
	console.error("[compile-typst] Could not parse SVG viewBox");
	process.exit(1);
}

const [, , , vbWidth, vbHeight] = viewBoxMatch[1].split(/\s+/).map(Number);

// A4 page height in Typst points is ~841.89, but detect from data attributes
const dataHeightMatch = svgStr.match(/data-height="([\d.]+)"/);
const totalHeight = dataHeightMatch ? Number(dataHeightMatch[1]) : vbHeight;

// Estimate page count: each A4 page ≈ 841.89pt
const PAGE_HEIGHT_PT = 841.89;
const pageCount = Math.round(totalHeight / PAGE_HEIGHT_PT);

const manifest = {
	pageCount: Math.max(pageCount, 1),
	pageWidth: vbWidth,
	pageHeight: PAGE_HEIGHT_PT,
	totalHeight,
};

fs.writeFileSync(path.join(OUT_DIR, "manifest.json"), JSON.stringify(manifest, null, 2));
console.log("[compile-typst] manifest.json written:", manifest);
console.log("[compile-typst] Done.");
