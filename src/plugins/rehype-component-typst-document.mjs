/// <reference types="mdast" />

import fs from "node:fs";
import path from "node:path";
import { h } from "hastscript";

/**
 * Creates a Typst Document preview component.
 *
 * Usage in markdown: ::typst{src="resume"}
 *
 * This renders a scrollable SVG preview of the compiled Typst document
 * with a PDF download button.
 *
 * @param {Object} properties - The properties of the component.
 * @param {string} properties.src - The document name (matches public/<src>/ output directory).
 * @param {import('mdast').RootContent[]} children - The children elements of the component.
 * @returns {import('mdast').Parent} The created Typst Document component.
 */
export function TypstDocumentComponent(properties, children) {
	if (Array.isArray(children) && children.length !== 0)
		return h("div", { class: "hidden" }, [
			'Invalid directive. ("typst" directive must be leaf type "::typst{src="name"}")',
		]);

	const src = properties.src;
	if (!src)
		return h(
			"div",
			{ class: "hidden" },
			'Invalid typst directive. ("src" attribute is required)',
		);

	const outDir = path.resolve("public", src);
	const manifestPath = path.join(outDir, "manifest.json");
	const svgPath = path.join(outDir, `${src}.svg`);
	const pdfPath = `/${src}/${src}.pdf`;
	const svgSrc = `/${src}/${src}.svg`;

	// Check if build artifacts exist
	let manifest = null;
	let svgExists = false;
	try {
		if (fs.existsSync(manifestPath)) {
			manifest = JSON.parse(fs.readFileSync(manifestPath, "utf-8"));
		}
		svgExists = fs.existsSync(svgPath);
	} catch {
		// Build artifacts not generated yet
	}

	if (!svgExists || !manifest) {
		return h(
			"div",
			{ class: "typst-not-available" },
			"Typst document not available — run build to generate.",
		);
	}

	const cardUuid = `TD${Math.random().toString(36).slice(-6)}`;

	// Download icon SVG (feather icons "download")
	const downloadIcon = h(
		"svg",
		{
			xmlns: "http://www.w3.org/2000/svg",
			width: "16",
			height: "16",
			viewBox: "0 0 24 24",
			fill: "none",
			stroke: "currentColor",
			"stroke-width": "2",
			"stroke-linecap": "round",
			"stroke-linejoin": "round",
		},
		[
			h("path", { d: "M21 15v4a2 2 0 0 1-2 2H5a2 2 0 0 1-2-2v-4" }),
			h("polyline", { points: "7 10 12 15 17 10" }),
			h("line", { x1: "12", y1: "15", x2: "12", y2: "3" }),
		],
	);

	// Build the preview container
	const nPreview = h("div", { class: "typst-scroll-container" }, [
		h("img", {
			src: svgSrc,
			alt: `${src} document`,
			loading: "lazy",
			decoding: "async",
			class: "typst-svg-img",
		}),
	]);

	// Link icon SVG (feather icons "link")
	const linkIcon = h(
		"svg",
		{
			xmlns: "http://www.w3.org/2000/svg",
			width: "16",
			height: "16",
			viewBox: "0 0 24 24",
			fill: "none",
			stroke: "currentColor",
			"stroke-width": "2",
			"stroke-linecap": "round",
			"stroke-linejoin": "round",
		},
		[
			h("path", {
				d: "M10 13a5 5 0 0 0 7.54.54l3-3a5 5 0 0 0-7.07-7.07l-1.72 1.71",
			}),
			h("path", {
				d: "M14 11a5 5 0 0 0-7.54-.54l-3 3a5 5 0 0 0 7.07 7.07l1.71-1.71",
			}),
		],
	);

	const nCopyScript = h(
		"script",
		{ type: "text/javascript", defer: true },
		`
      document.getElementById('${cardUuid}-copy').addEventListener('click', function(e) {
        e.preventDefault();
        var url = new URL('${pdfPath}', window.location.origin).href;
        navigator.clipboard.writeText(url).then(function() {
          var btn = document.getElementById('${cardUuid}-copy');
          var orig = btn.textContent;
          btn.lastChild.textContent = ' Copied!';
          setTimeout(function() { btn.lastChild.textContent = ' Copy Link'; }, 1500);
        });
      });
    `,
	);

	const nActions = h("div", { class: "typst-actions" }, [
		h(
			"a",
			{
				href: pdfPath,
				download: true,
				class: "typst-download-btn",
			},
			[downloadIcon, " Download PDF"],
		),
		h(
			"a",
			{
				id: `${cardUuid}-copy`,
				href: pdfPath,
				class: "typst-copy-btn",
			},
			[linkIcon, " Copy Link"],
		),
		nCopyScript,
	]);

	return h(`div#${cardUuid}`, { class: "card-typst" }, [nPreview, nActions]);
}
