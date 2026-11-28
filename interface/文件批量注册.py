#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
GFX 资源注册代码生成器 (Clausewitz / HOI4 风格 SpriteType)

功能:
    扫描指定文件夹中的 dds/png/jpg/jpeg 图片,
    按文件名生成 SpriteType 注册代码, 输出到 txt 文件。

示例:
    # 命令行方式
    python gfx_registry.py -i "D:/mod/gfx/leaders/SKR" -p "gfx/leaders/SKR" -o "out.txt" -r

    # 交互式方式 (会弹窗选择文件夹)
    python gfx_registry.py
"""

from __future__ import annotations

import argparse
import sys
from pathlib import Path

# ---------------------------- 常量 ----------------------------

SUPPORTED_EXTS = {".dds", ".png", ".jpg", ".jpeg"}

DEFAULT_OUTPUT_NAME = "gfx_registry.txt"

# 生成代码的模板; 使用 str.format, 花括号需要转义为 {{ }}
SPRITE_TEMPLATE = """SpriteType = {{
    name = "GFX_{name}"
    texturefile = "{texture}"
}}
"""


# ------------------------- 文件对话框 -------------------------

def pick_folder(title: str) -> str:
    """弹出文件夹选择框, 取消/不可用时返回空字符串。"""
    try:
        import tkinter as tk
        from tkinter import filedialog
    except Exception:
        return ""
    try:
        root = tk.Tk()
        root.withdraw()
        path = filedialog.askdirectory(title=title)
        root.destroy()
        return path or ""
    except Exception:
        return ""


def pick_save_file(title: str, default: str = "") -> str:
    """弹出保存文件对话框, 取消/不可用时返回空字符串。"""
    try:
        import tkinter as tk
        from tkinter import filedialog
    except Exception:
        return ""
    default_path = Path(default) if default else None
    try:
        root = tk.Tk()
        root.withdraw()
        path = filedialog.asksaveasfilename(
            title=title,
            defaultextension=".txt",
            initialfile=default_path.name if default_path else DEFAULT_OUTPUT_NAME,
            initialdir=str(default_path.parent) if default_path else None,
            filetypes=[("文本文件", "*.txt"), ("所有文件", "*.*")],
        )
        root.destroy()
        return path or ""
    except Exception:
        return ""


def prompt(text: str, default: str = "") -> str:
    """终端输入提示, 空输入时返回默认值。"""
    suffix = f" [默认: {default}]" if default else ""
    try:
        value = input(f"{text}{suffix}: ").strip()
    except EOFError:
        value = ""
    return value or default


# --------------------------- 核心逻辑 ---------------------------

def collect_images(folder: Path, recursive: bool) -> list[Path]:
    """收集指定文件夹下所有受支持的图片文件。"""
    pattern = "**/*" if recursive else "*"
    files = [
        p for p in folder.glob(pattern)
        if p.is_file() and p.suffix.lower() in SUPPORTED_EXTS
    ]
    # 按相对路径排序, 保证输出顺序稳定
    return sorted(files, key=lambda p: str(p.relative_to(folder)).lower())


def make_texture_path(file: Path, base: Path, prefix: str,
                      keep_subdirs: bool) -> str:
    """生成 texturefile 字段的路径。"""
    if keep_subdirs:
        rel = file.relative_to(base).as_posix()
    else:
        rel = file.name

    prefix = prefix.replace("\\", "/").strip().strip("/")
    return f"{prefix}/{rel}" if prefix else rel


def build_registry(files: list[Path], base: Path, prefix: str,
                   keep_subdirs: bool = True):
    """
    生成注册代码列表。

    返回:
        entries     : list[str]  每条 SpriteType 代码块
        duplicates  : dict       同名冲突的文件 (name -> [paths])
    """
    entries: list[str] = []
    seen: dict[str, str] = {}
    duplicates: dict[str, list[str]] = {}

    for f in files:
        name = f.stem                      # 去掉扩展名的文件名
        if name in seen:
            duplicates.setdefault(name, [seen[name]]).append(str(f))
            continue
        seen[name] = str(f)

        texture = make_texture_path(f, base, prefix, keep_subdirs)
        entries.append(SPRITE_TEMPLATE.format(name=name, texture=texture))

    return entries, duplicates


# ----------------------------- 主程序 -----------------------------

def main(argv=None) -> int:
    parser = argparse.ArgumentParser(
        description="扫描 dds/png/jpg 图片, 生成 GFX (SpriteType) 注册代码。",
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog=(
            "示例:\n"
            "  python gfx_registry.py -i ./gfx/leaders/SKR -p gfx/leaders/SKR -o out.txt -r\n"
            "  python gfx_registry.py            # 交互式\n"
        ),
    )
    parser.add_argument("-i", "--input", help="图片所在文件夹")
    parser.add_argument("-p", "--texture-prefix", default="",
                        help="texturefile 路径前缀, 例如 gfx/leaders/SKR")
    parser.add_argument("-o", "--output", help="输出的 txt 文件路径")
    parser.add_argument("-r", "--recursive", action="store_true",
                        help="递归扫描子文件夹")
    parser.add_argument("--flat", action="store_true",
                        help="不保留子文件夹结构 (默认保留)")
    parser.add_argument("--no-gui", action="store_true",
                        help="禁用文件对话框, 全部用终端输入")
    args = parser.parse_args(argv)

    interactive = args.input is None
    use_gui = not args.no_gui

    # ---------- 1. 输入文件夹 ----------
    if interactive:
        print("=" * 50)
        print("         GFX 资源注册代码生成器")
        print("=" * 50)
        folder = pick_folder("请选择包含图片的文件夹") if use_gui else ""
        if not folder:
            folder = prompt("请输入图片文件夹路径")
        if not folder:
            print("错误: 未指定输入文件夹。")
            return 1
        input_dir = Path(folder).expanduser()
    else:
        input_dir = Path(args.input).expanduser()

    if not input_dir.is_dir():
        print(f"错误: 输入路径不是文件夹 -> {input_dir}")
        return 1

    # ---------- 2. texturefile 前缀 ----------
    texture_prefix = args.texture_prefix
    if not texture_prefix and interactive:
        # 智能默认值: 尝试猜测 gfx/xxx/文件夹名
        guess = f"gfx/{input_dir.name}" if input_dir.name else ""
        texture_prefix = prompt("请输入 texturefile 路径前缀 (可留空)", guess)

    # ---------- 3. 是否递归 ----------
    if args.recursive:
        recursive = True
    elif interactive:
        ans = prompt("是否递归扫描子文件夹? (y/N)", "N").lower()
        recursive = ans in ("y", "yes", "是")
    else:
        recursive = False

    # ---------- 4. 输出文件 ----------
    if args.output:
        output = Path(args.output).expanduser()
    elif interactive:
        default_out = str(input_dir / DEFAULT_OUTPUT_NAME)
        out = pick_save_file("保存注册代码到...", default_out) if use_gui else ""
        if not out:
            out = prompt("请输入输出 txt 文件路径", default_out)
        output = Path(out).expanduser()
    else:
        output = input_dir / DEFAULT_OUTPUT_NAME

    # 若给出的是已存在的文件夹, 则自动补默认文件名
    if output.is_dir():
        output = output / DEFAULT_OUTPUT_NAME

    # ---------- 5. 扫描并生成 ----------
    print(f"\n正在扫描: {input_dir}  (递归={recursive})")
    files = collect_images(input_dir, recursive)

    if not files:
        print("未找到任何 dds/png/jpg 图片文件。")
        return 1

    entries, duplicates = build_registry(
        files, input_dir, texture_prefix,
        keep_subdirs=not args.flat,
    )

    output.parent.mkdir(parents=True, exist_ok=True)
    output.write_text("\n".join(entries) + "\n", encoding="utf-8")

    # ---------- 6. 结果反馈 ----------
    print("-" * 50)
    print(f"扫描到图片 : {len(files)} 个")
    print(f"生成条目   : {len(entries)} 条")
    print(f"输出文件   : {output.resolve()}")

    if duplicates:
        print("\n[警告] 以下文件名重复, 已跳过 (GFX 名称会冲突):")
        for name, paths in duplicates.items():
            print(f"  GFX_{name}:")
            for p in paths:
                print(f"    - {p}")

    print("\n完成。")
    return 0


if __name__ == "__main__":
    sys.exit(main())