const { src, dest, series } = require("gulp");
const { writeFileSync } = require("fs");
const rename = require("gulp-rename");
const path = require("path");
var iconfont = require("gulp-iconfont");
var runTimestamp = Math.round(Date.now() / 1000);
var walk = require("walkdir");

function generateTTF() {
    return src(["../assets/icon-font/*.svg"])
        .pipe(
            rename(path => {
                if (path.dirname != ".") {
                    path.basename = `${path.dirname.replace(/\//g, "_")}_${
                        path.basename
                        }`;
                }
            })
        )
        .pipe(dest("./.icons"))
        .pipe(
            iconfont({
                fontName: "iconfont", // required
                //                fixedWidth: true,
                normalize: true,
                fontHeight: 1000,
                prependUnicode: true, // recommended option
                formats: ["ttf"],
                timestamp: runTimestamp // recommended to get consistent builds when watching files
            })
        )
        .on("glyphs", function (glyphs, options) {
            const icons = glyphs.map(glyph => {
                const code = "0x" + glyph.unicode[0].charCodeAt(0).toString(16);
                const name = camelNaming(glyph.name,false);
                console.log(`code: ${code}    name: ${name}`);
                return { code, name };
            });
            generateDartFile(icons);
        })
        .pipe(dest("../assets/fonts/"));
}

function camelNaming(name, capitalize = true) {
    let res = "";
    let parts = name.split("_");
    if (!capitalize) {
        res += parts.shift();
    }
    for (let part of parts) {
        part = part[0].toUpperCase() + part.substr(1);
        res += part;
    }
    return res;
}

function generateDartFile(icons) {
    let lines = "";
    for (let icon of icons) {
        lines += `  static const IconData ${icon.name} = IconData(${icon.code}, fontFamily: "iconfont", fontPackage: "lib_ui");\n`;
    }
    let content = `// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/widgets.dart';
class IconFont {
  IconFont._();
${lines}
}
`;
    const outFile = "../lib/icon_font.dart";
    writeFileSync(outFile, content);
}

async function generateSVGListDartFile() {
    function generateDartFile(icons) {
        let lines = "";
        for (let icon of icons) {
            console.log(icon);
            const name = camelNaming(
                icon
                    .replace("assets/", "")
                    .replace(/[/\- ]/g, "_")
                    .replace(".svg", ""),
                false
            );
            lines += `  static const ${name} = "${icon}";\n`;
        }
        let content = `// GENERATED CODE - DO NOT MODIFY BY HAND
    class SvgIcons {
      SvgIcons._();
    ${lines}
    }
    `;
        const outFile = "../lib/svg_icons.dart";
        writeFileSync(outFile, content);
    }

    const files = walk
        .sync("../assets", { no_recurse: false })
        .filter(e => e.endsWith(".svg"))
        .map(e => path.relative("../social", e))
        .map(e => e.replace(/\\/g, '/'))
        .filter(e => !e.startsWith("assets/icon-font/"));
    generateDartFile(files);
}

exports.generateSVGListDartFile = generateSVGListDartFile;
exports.generateTTF = generateTTF;
