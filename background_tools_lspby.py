import os
import re
import shutil
import sys
import subprocess
import importlib.util
from typing import List, Dict, Tuple
import tempfile

try:
    from tqdm import tqdm
except ImportError:
    print("正在安装进度条依赖库 tqdm...")
    subprocess.check_call([sys.executable, "-m", "pip", "install", "tqdm", "-q"])
    from tqdm import tqdm

try:
    import imageio.v3 as iio
except ImportError:
    iio = None
try:
    import numpy as np
except ImportError:
    np = None
try:
    from PIL import Image
except ImportError:
    Image = None

class ConsoleColor:
    RED = '\033[91m'
    GREEN = '\033[92m'
    YELLOW = '\033[93m'
    BLUE = '\033[94m'
    RESET = '\033[0m'

    @staticmethod
    def green(text):
        if os.name == 'nt':
            return text
        return f"{ConsoleColor.GREEN}{text}{ConsoleColor.RESET}"

    @staticmethod
    def red(text):
        if os.name == 'nt':
            return text
        return f"{ConsoleColor.RED}{text}{ConsoleColor.RESET}"

    @staticmethod
    def yellow(text):
        if os.name == 'nt':
            return text
        return f"{ConsoleColor.YELLOW}{text}{ConsoleColor.RESET}"

    @staticmethod
    def blue(text):
        if os.name == 'nt':
            return text
        return f"{ConsoleColor.BLUE}{text}{ConsoleColor.RESET}"

AUTHOR = "洗不白de衣服"
CODE_VERSION = "v1.1"

def get_config_file_path():
    script_dir = os.path.dirname(os.path.abspath(sys.argv[0]))
    config_filename = "background_tools_lspby_record.txt"
    
    test_path = os.path.join(script_dir, config_filename)
    if is_path_writable(test_path):
        return test_path
    
    user_dir = os.path.expanduser("~")
    test_path = os.path.join(user_dir, config_filename)
    if is_path_writable(test_path):
        return test_path
    
    temp_dir = tempfile.gettempdir()
    test_path = os.path.join(temp_dir, config_filename)
    return test_path

def is_path_writable(file_path):
    if os.path.exists(file_path):
        try:
            with open(file_path, 'a', encoding='utf-8') as f:
                f.write("")
            return True
        except (PermissionError, OSError):
            return False
    else:
        dir_path = os.path.dirname(file_path)
        if not dir_path:
            dir_path = os.getcwd()
        try:
            temp_file = tempfile.NamedTemporaryFile(dir=dir_path, delete=True)
            return True
        except (PermissionError, OSError):
            return False

RECORD_FILE = get_config_file_path()

DEFAULT_CONFIG = {
    "mod_paths": [],
    "check_lib_on_start": "Y"
}

MOD_ROOT_DIR = ""
LOADING_SCREEN_DIR = ""
BACKGROUND_TXT_PATH = ""
SMALL_BACKGROUND_GFX_PATH = ""
BACKUP_SUFFIX = ".bak"

REQUIRED_PACKAGES = {
    "imageio": "2.33.0",
    "imageio-ffmpeg": "0.4.9",
    "Pillow": "10.0.0",
    "tqdm": "4.66.0"
}

def clear_screen():
    os.system('cls' if os.name == 'nt' else 'clear')

def load_config():
    config = DEFAULT_CONFIG.copy()
    try:
        if os.path.exists(RECORD_FILE):
            with open(RECORD_FILE, 'r', encoding='utf-8') as f:
                for line in f:
                    line = line.strip()
                    if not line or line.startswith("#"):
                        continue
                    if "=" not in line:
                        continue
                    key, value = line.split("=", 1)
                    key = key.strip()
                    value = value.strip()
                    if key == "mod_paths":
                        config[key] = value.split("|") if value else []
                    else:
                        config[key] = value
        print(ConsoleColor.blue(f"[信息] 配置文件路径：{RECORD_FILE}"))
    except Exception as e:
        print(ConsoleColor.yellow(f"[警告] 加载配置文件失败，使用默认配置：{e}"))
    return config

def save_config(config):
    try:
        config_dir = os.path.dirname(RECORD_FILE)
        if not os.path.exists(config_dir):
            os.makedirs(config_dir, exist_ok=True)
        
        with open(RECORD_FILE, 'w', encoding='utf-8') as f:
            f.write(f"# 钢铁雄心IV加载图处理工具配置文件\n")
            f.write(f"# 作者：{AUTHOR}\n")
            f.write(f"check_lib_on_start={config['check_lib_on_start']}\n")
            f.write(f"mod_paths={'|'.join(config['mod_paths'])}\n")
        print(ConsoleColor.green(f"[成功] 配置已保存到：{RECORD_FILE}"))
    except PermissionError:
        print(ConsoleColor.red(f"[失败] 无权限写入配置文件：{RECORD_FILE}"))
        print(ConsoleColor.yellow(f"[建议] 请以管理员身份运行程序，或更换运行目录"))
    except Exception as e:
        print(ConsoleColor.red(f"[失败] 保存配置文件失败：{e}"))

def select_mod_path(config):
    clear_screen()
    print("="*60)
    print("                    选择/输入MOD根目录")
    print("="*60)
    
    mod_paths = config["mod_paths"]
    if mod_paths:
        print("历史MOD路径：")
        for idx, path in enumerate(mod_paths, 1):
            print(f"[{idx}] {path}")
        print("[0] 输入新的MOD路径")
        choice = input("\n请选择（输入数字）：").strip()
        try:
            choice = int(choice)
            if 1 <= choice <= len(mod_paths):
                selected_path = mod_paths[choice-1]
                if os.path.exists(selected_path):
                    print(f"\n已选择：{selected_path}")
                    return selected_path
                else:
                    print(f"\n路径 {selected_path} 不存在，将重新输入")
                    input("\n按回车继续...")
            elif choice == 0:
                pass
            else:
                print("\n输入无效，将重新输入")
                input("\n按回车继续...")
        except ValueError:
            print("\n输入无效，将重新输入")
            input("\n按回车继续...")
    
    while True:
        clear_screen()
        print("="*60)
        print("                    输入新的MOD根目录")
        print("="*60)
        new_path = input("\n请输入MOD根目录路径：").strip()
        if not new_path:
            print("路径不能为空！")
            input("\n按回车重新输入...")
            continue
        new_path = os.path.abspath(new_path)
        if os.path.exists(new_path):
            if new_path not in mod_paths:
                mod_paths.append(new_path)
                if len(mod_paths) > 5:
                    mod_paths.pop(0)
                config["mod_paths"] = mod_paths
                save_config(config)
            print(f"\n路径验证成功：{new_path}")
            input("\n按回车继续...")
            return new_path
        else:
            confirm = input(f"\n路径 {new_path} 不存在，是否确认使用该路径？(Y/N)：").strip().upper()
            if confirm == "Y":
                if new_path not in mod_paths:
                    mod_paths.append(new_path)
                    if len(mod_paths) > 5:
                        mod_paths.pop(0)
                    config["mod_paths"] = mod_paths
                    save_config(config)
                print(f"\n已确认使用路径：{new_path}")
                input("\n按回车继续...")
                return new_path

def init_global_paths(mod_root):
    global MOD_ROOT_DIR, LOADING_SCREEN_DIR, BACKGROUND_TXT_PATH, SMALL_BACKGROUND_GFX_PATH
    MOD_ROOT_DIR = mod_root
    LOADING_SCREEN_DIR = os.path.join(MOD_ROOT_DIR, "gfx", "loadingscreens")
    BACKGROUND_TXT_PATH = os.path.join(MOD_ROOT_DIR, "common", "frontend", "backgrounds", "base_backgrounds.txt")
    SMALL_BACKGROUND_GFX_PATH = os.path.join(MOD_ROOT_DIR, "interface", "small_background.gfx")

def check_package_installed(package_name: str) -> Tuple[bool, str]:
    try:
        importlib.invalidate_caches()
        
        name_mapping = {
            "Pillow": "PIL",
            "imageio-ffmpeg": "imageio_ffmpeg"
        }
        import_name = name_mapping.get(package_name, package_name).replace("-", "_")
        
        spec = importlib.util.find_spec(import_name)
        if spec is None:
            return False, ""
        
        module = importlib.import_module(import_name)
        
        if getattr(sys, 'frozen', False):
            return True, "bundled"
        
        if import_name == "PIL":
            version = module.__version__
        elif import_name == "imageio_ffmpeg":
            version = module.__version__
        else:
            version = module.__version__ if hasattr(module, "__version__") else "unknown"
        
        return True, version
    except Exception as e:
        if getattr(sys, 'frozen', False) and "package metadata" in str(e):
            return True, "bundled"
        print(f"检测 {package_name} 时出错：{str(e)}")
        return False, ""

def get_latest_package_version(package_name: str) -> str:
    try:
        result = subprocess.check_output(
            [sys.executable, "-m", "pip", "index", "versions", package_name, "--quiet"],
            text=True,
            stderr=subprocess.DEVNULL
        )
        for line in result.splitlines():
            if "latest" in line.lower():
                version_match = re.search(r'(\d+\.\d+\.\d+(\.\d+)?)', line)
                if version_match:
                    return version_match.group(1)
        return ""
    except Exception:
        try:
            result = subprocess.check_output(
                [sys.executable, "-m", "pip", "install", f"{package_name}==random", "--dry-run"],
                text=True,
                stderr=subprocess.STDOUT
            )
            version_match = re.search(r'from versions: (.*?)\)', result)
            if version_match:
                versions = version_match.group(1).split(", ")
                return versions[-1] if versions else ""
        except Exception:
            return ""

def check_all_dependencies() -> Dict[str, Dict[str, str]]:
    result = {
        "missing": [],
        "outdated": [],
        "up_to_date": []
    }
    
    with tqdm(total=len(REQUIRED_PACKAGES), desc="检测依赖库", unit="包", ncols=100, colour="green") as pbar:
        for pkg_name, min_version in REQUIRED_PACKAGES.items():
            pbar.set_postfix({"当前检测": pkg_name}, refresh=True)
            
            is_installed, current_version = check_package_installed(pkg_name)
            if not is_installed:
                result["missing"].append({
                    "name": pkg_name,
                    "current_version": "",
                    "latest_version": get_latest_package_version(pkg_name)
                })
                pbar.update(1)
                continue
            
            latest_version = get_latest_package_version(pkg_name)
            if not latest_version:
                result["up_to_date"].append({
                    "name": pkg_name,
                    "current_version": current_version,
                    "latest_version": current_version
                })
                pbar.update(1)
                continue
            
            def version_tuple(version: str) -> Tuple[int, ...]:
                return tuple(map(int, version.split("."))) if version else (0, 0, 0)
            
            if version_tuple(current_version) < version_tuple(latest_version):
                result["outdated"].append({
                    "name": pkg_name,
                    "current_version": current_version,
                    "latest_version": latest_version
                })
            else:
                result["up_to_date"].append({
                    "name": pkg_name,
                    "current_version": current_version,
                    "latest_version": latest_version
                })
            
            pbar.update(1)
    
    return result

def install_or_update_package(pkg_name: str, target_version: str = "") -> bool:
    try:
        pkg_spec = pkg_name if not target_version else f"{pkg_name}=={target_version}"
        cmd = [sys.executable, "-m", "pip", "install", "-U", "--no-cache-dir", pkg_spec, "--quiet"]
        
        with tqdm(total=100, desc=f"安装/更新 {pkg_name}", unit="%", ncols=100, colour="blue") as pbar:
            process = subprocess.Popen(
                cmd,
                stdout=subprocess.PIPE,
                stderr=subprocess.STDOUT,
                text=True,
                bufsize=1
            )
            
            progress_pattern = re.compile(r'(\d+)%|(\d+\.\d+)%')
            while process.poll() is None:
                line = process.stdout.readline()
                if line:
                    progress_match = progress_pattern.search(line)
                    if progress_match:
                        progress = float(progress_match.group(1) or progress_match.group(2))
                        pbar.update(progress - pbar.n)
            
            if pbar.n < 100:
                pbar.update(100 - pbar.n)
            
            if process.returncode == 0:
                is_installed, _ = check_package_installed(pkg_name)
                return is_installed
            return False
    except Exception as e:
        print(f"\n{pkg_name} 安装/更新失败：{str(e)}")
        return False

def handle_dependencies(config):
    if config["check_lib_on_start"].upper() != "Y":
        clear_screen()
        print("="*60)
        print(f"                钢铁雄心IV 加载图处理工具 {CODE_VERSION}")
        print(f"                代码作者：{AUTHOR}")
        print("="*60)
        print("已跳过依赖库验证（可在配置中开启）")
        print("="*60 + "\n")
        input("按回车继续...")
        return
    
    clear_screen()
    print("="*60)
    print(f"                钢铁雄心IV 加载图处理工具 {CODE_VERSION}")
    print(f"                代码作者：{AUTHOR}")
    print("="*60)
    print("开始检测依赖库（可在配置中关闭）")
    print("="*60)
    
    dep_result = check_all_dependencies()
    
    print("\n" + "="*60)
    print("依赖库检测结果：")
    print(f"已最新：{len(dep_result['up_to_date'])} 个")
    for pkg in dep_result['up_to_date']:
        print(f"   - {pkg['name']} ({pkg['current_version']})")
    
    print(f"需更新：{len(dep_result['outdated'])} 个")
    for pkg in dep_result['outdated']:
        print(f"   - {pkg['name']}: {pkg['current_version']} → {pkg['latest_version']}")
    
    print(f"缺失：{len(dep_result['missing'])} 个")
    for pkg in dep_result['missing']:
        print(f"   - {pkg['name']} (需要安装 {pkg['latest_version']})")
    
    if dep_result['missing']:
        print("\n" + "="*60)
        print("开始安装缺失的依赖库...")
        for pkg in dep_result['missing']:
            success = install_or_update_package(pkg['name'], pkg['latest_version'])
            if success:
                print(f"\n{ConsoleColor.green('[成功]')} {pkg['name']} 安装成功")
            else:
                print(f"\n{ConsoleColor.red('[失败]')} {pkg['name']} 安装失败，请手动执行：pip install {pkg['name']}")
                sys.exit(1)
    
    if dep_result['outdated']:
        print("\n" + "="*60)
        print("开始更新依赖库...")
        for pkg in dep_result['outdated']:
            success = install_or_update_package(pkg['name'], pkg['latest_version'])
            if success:
                print(f"\n{ConsoleColor.green('[成功]')} {pkg['name']} 更新成功 ({pkg['current_version']} → {pkg['latest_version']})")
            else:
                print(f"\n{ConsoleColor.yellow('[警告]')} {pkg['name']} 更新失败，将使用当前版本 {pkg['current_version']}")
    
    print("\n" + "="*60)
    print("验证依赖库可用性...")
    final_check = check_all_dependencies()
    if final_check['missing']:
        print(f"\n以下依赖仍缺失，程序无法运行：")
        for pkg in final_check['missing']:
            print(f"   - {pkg['name']}")
        print(f"\n手动修复命令：{sys.executable} -m pip install {' '.join([p['name'] for p in final_check['missing']])} --upgrade")
        input("\n按回车退出...")
        sys.exit(1)
    else:
        print(f"\n{ConsoleColor.green('[成功]')} 所有依赖库均已就绪！")
        print("="*60 + "\n")
        input("按回车继续...")

def generate_dds_thumbnails(is_batch=False, batch_output=None):
    if not is_batch:
        clear_screen()
        print("="*60)
        print("                    生成加载图缩略图")
        print("="*60)
    
    output_lines = []
    def print_and_collect(text):
        print(text)
        if is_batch and batch_output is not None:
            batch_output.append(text)
    
    if not os.path.exists(LOADING_SCREEN_DIR):
        error_msg = f"\n错误：加载图目录 {LOADING_SCREEN_DIR} 不存在！"
        print_and_collect(error_msg)
        if not is_batch:
            input("\n按回车返回菜单...")
        return
    
    pattern = re.compile(r'^load_(.*?)\.dds$', re.IGNORECASE)
    small_pattern = re.compile(r'_small\.dds$', re.IGNORECASE)
    
    found_originals = 0
    generated_thumbnails = 0
    failed_files = []
    
    print_and_collect("\n开始扫描并生成缩略图...")
    for filename in os.listdir(LOADING_SCREEN_DIR):
        if small_pattern.search(filename):
            continue
        
        match = pattern.match(filename)
        if match:
            found_originals += 1
            file_core = match.group(1)
            thumbnail_name = f"load_{file_core}_small.dds"
            thumbnail_path = os.path.join(LOADING_SCREEN_DIR, thumbnail_name)
            
            if os.path.exists(thumbnail_path):
                skip_msg = f"{filename} - 缩略图已存在，跳过"
                print_and_collect(skip_msg)
                continue
            
            original_path = os.path.join(LOADING_SCREEN_DIR, filename)
            try:
                process_msg = f"正在处理：{filename}"
                print_and_collect(process_msg)
                img_data = iio.imread(original_path)
                img = Image.fromarray(img_data)
                
                if img.size != (1920, 1440):
                    size_msg = f"{filename} - 原图尺寸为 {img.size}（非1920 * 1440），仍生成缩略图"
                    print_and_collect(size_msg)
                
                thumbnail_img = img.resize((192, 144), Image.Resampling.LANCZOS)
                thumbnail_data = np.array(thumbnail_img)
                iio.imwrite(thumbnail_path, thumbnail_data, extension=".dds")
                
                generated_thumbnails += 1
                success_msg = f"{filename} - 缩略图 {thumbnail_name} 生成成功"
                print_and_collect(success_msg)
            
            except Exception as e:
                error_msg = f"{filename} - 处理失败：{str(e)}"
                print_and_collect(error_msg)
                failed_files.append((filename, str(e)))
    
    print_and_collect("\n" + "="*40)
    print_and_collect("缩略图生成统计：")
    print_and_collect(f"   检测到原图数量：{found_originals}")
    print_and_collect(f"   成功生成缩略图：{generated_thumbnails}")
    print_and_collect(f"   处理失败文件数：{len(failed_files)}")
    
    if failed_files:
        print_and_collect("\n处理失败的文件：")
        for file, error in failed_files:
            print_and_collect(f"   {file}：{error}")
    
    if not is_batch:
        input("\n按回车返回菜单...")

def register_background_database(is_batch=False, batch_output=None):
    if not is_batch:
        clear_screen()
        print("="*60)
        print("                    注册大图到背景数据库")
        print("="*60)
    
    output_lines = []
    def print_and_collect(text):
        print(text)
        if is_batch and batch_output is not None:
            batch_output.append(text)
    
    background_dir = os.path.dirname(BACKGROUND_TXT_PATH)
    if not os.path.exists(background_dir):
        os.makedirs(background_dir)
        create_msg = f"\n自动创建目录：{background_dir}"
        print_and_collect(create_msg)
    
    if os.path.exists(BACKGROUND_TXT_PATH):
        backup_path = BACKGROUND_TXT_PATH + BACKUP_SUFFIX
        shutil.copy2(BACKGROUND_TXT_PATH, backup_path)
        backup_msg = f"\n已备份原文件到：{backup_path}"
        print_and_collect(backup_msg)
    
    pattern = re.compile(r'^load_(.*?)\.dds$', re.IGNORECASE)
    small_pattern = re.compile(r'_small\.dds$', re.IGNORECASE)
    background_entries = set()
    
    print_and_collect("\n扫描加载图原图...")
    for filename in os.listdir(LOADING_SCREEN_DIR):
        if small_pattern.search(filename):
            continue
        match = pattern.match(filename)
        if match:
            file_core = match.group(1)
            entry = f"load_{file_core} = {{}}"
            background_entries.add(entry)
    
    if not background_entries:
        no_entry_msg = "\n未找到任何需要注册的加载图原图！"
        print_and_collect(no_entry_msg)
        if not is_batch:
            input("\n按回车返回菜单...")
        return
    
    existing_entries = set()
    if os.path.exists(BACKGROUND_TXT_PATH):
        with open(BACKGROUND_TXT_PATH, 'r', encoding='utf-8') as f:
            for line in f:
                line_stripped = line.strip()
                if re.match(r'^load_\w+ = \{\}$', line_stripped):
                    existing_entries.add(line_stripped)
    
    all_entries = existing_entries.union(background_entries)
    sorted_entries = sorted(all_entries, key=lambda x: x)
    
    try:
        with open(BACKGROUND_TXT_PATH, 'w', encoding='utf-8') as f:
            for entry in sorted_entries:
                f.write(entry + "\n")
        success_msg = f"\n{ConsoleColor.green('[成功]')} 注册 {len(sorted_entries)} 个背景条目到 {BACKGROUND_TXT_PATH}"
        print_and_collect(success_msg)
        print_and_collect("注册格式示例：")
        print_and_collect("   load_1 = {}")
        print_and_collect("   load_eastern_europe = {}")
    except Exception as e:
        error_msg = f"\n{ConsoleColor.red('[失败]')} 写入文件失败：{str(e)}"
        print_and_collect(error_msg)
    
    if not is_batch:
        input("\n按回车返回菜单...")

def register_small_background_gfx(is_batch=False, batch_output=None):
    if not is_batch:
        clear_screen()
        print("="*60)
        print("                    注册缩略图到small_background.gfx")
        print("="*60)
    
    output_lines = []
    def print_and_collect(text):
        print(text)
        if is_batch and batch_output is not None:
            batch_output.append(text)
    
    gfx_dir = os.path.dirname(SMALL_BACKGROUND_GFX_PATH)
    if not os.path.exists(gfx_dir):
        os.makedirs(gfx_dir)
        create_msg = f"\n自动创建目录：{gfx_dir}"
        print_and_collect(create_msg)
    
    if os.path.exists(SMALL_BACKGROUND_GFX_PATH):
        backup_path = SMALL_BACKGROUND_GFX_PATH + BACKUP_SUFFIX
        shutil.copy2(SMALL_BACKGROUND_GFX_PATH, backup_path)
        backup_msg = f"\n已备份原文件到：{backup_path}"
        print_and_collect(backup_msg)
    
    small_pattern = re.compile(r'^load_(.*?)_small\.dds$', re.IGNORECASE)
    sprite_entries = []
    sprite_names = set()
    
    print_and_collect("\n扫描加载图缩略图...")
    for filename in os.listdir(LOADING_SCREEN_DIR):
        match = small_pattern.match(filename)
        if match:
            file_core = match.group(1)
            sprite_name = f"GFX_load_{file_core}_small"
            texture_path = f"gfx/loadingscreens/{filename}"
            
            sprite_block = f"""    spriteType = {{
        name = "{sprite_name}"
        texturefile = "{texture_path}"
    }}"""
            sprite_entries.append(sprite_block)
            sprite_names.add(sprite_name)
    
    if not sprite_entries:
        no_entry_msg = "\n未找到任何需要注册的缩略图！"
        print_and_collect(no_entry_msg)
        if not is_batch:
            input("\n按回车返回菜单...")
        return
    
    gfx_header = "spriteTypes = {"
    gfx_footer = "}"
    final_content = [gfx_header]
    final_content.extend(sprite_entries)
    final_content.append(gfx_footer)
    
    try:
        with open(SMALL_BACKGROUND_GFX_PATH, 'w', encoding='utf-8') as f:
            f.write("\n".join(final_content))
        success_msg = f"\n{ConsoleColor.green('[成功]')} 注册 {len(sprite_entries)} 个缩略图条目到 {SMALL_BACKGROUND_GFX_PATH}（已清空原有内容）"
        print_and_collect(success_msg)
        print_and_collect("注册格式示例：")
        print_and_collect("    spriteType = {")
        print_and_collect('        name = "GFX_load_1_small"')
        print_and_collect('        texturefile = "gfx/loadingscreens/load_1_small.dds"')
        print_and_collect("    }")
    except Exception as e:
        error_msg = f"\n{ConsoleColor.red('[失败]')} 写入文件失败：{str(e)}"
        print_and_collect(error_msg)
    
    if not is_batch:
        input("\n按回车返回菜单...")

def show_menu(config):
    clear_screen()
    print("="*60)
    print(f"                钢铁雄心IV 加载图处理工具 {CODE_VERSION}")
    print(f"                代码作者：{AUTHOR}")
    print(f"                当前MOD路径：{MOD_ROOT_DIR}")
    print(f"                启动验证库：{config['check_lib_on_start']}")
    print(f"                配置文件路径：{RECORD_FILE}")
    print("="*60)
    print("[1] 生成加载图缩略图 | 192 * 144 DDS")
    print("[2] 注册大图到背景数据库 | base_backgrounds.txt")
    print("[3] 注册缩略图到small_background.gfx")
    print("[4] 执行全部功能 | 1→2→3（自动执行）")
    print("[5] 修改配置 | 启动验证库/更换MOD路径")
    print("[0] 退出程序")
    print("="*60)
    print("")

def modify_config(config):
    while True:
        clear_screen()
        print("="*60)
        print("                    修改配置")
        print("="*60)
        print(f"当前配置：")
        print(f"1. 每次启动验证依赖库：{config['check_lib_on_start']} (Y=是/N=否)")
        print(f"2. 当前MOD路径：{MOD_ROOT_DIR}")
        print(f"3. 配置文件路径：{RECORD_FILE}")
        print("="*60)
        
        print("\n请选择要修改的项：")
        print("[1] 修改启动验证库设置")
        print("[2] 更换MOD路径")
        print("[3] 重置所有配置")
        print("[0] 返回菜单")
        
        choice = input("\n输入选择：").strip()
        if choice == "1":
            clear_screen()
            print("="*60)
            print("                    修改启动验证库设置")
            print("="*60)
            new_setting = input(f"\n当前设置：{config['check_lib_on_start']}\n是否每次启动验证依赖库？(Y/N)：").strip().upper()
            if new_setting in ["Y", "N"]:
                config["check_lib_on_start"] = new_setting
                save_config(config)
                print(f"\n{ConsoleColor.green('[成功]')} 配置已更新：启动验证库={new_setting}")
            else:
                print(f"\n{ConsoleColor.red('[失败]')} 输入无效，仅支持Y/N！")
            input("\n按回车继续...")
        elif choice == "2":
            new_mod_path = select_mod_path(config)
            init_global_paths(new_mod_path)
            print(f"\n{ConsoleColor.green('[成功]')} MOD路径已更新为：{new_mod_path}")
            input("\n按回车继续...")
        elif choice == "3":
            clear_screen()
            print("="*60)
            print("                    重置配置")
            print("="*60)
            confirm = input("\n确定要重置所有配置吗？(Y/N)：").strip().upper()
            if confirm == "Y":
                config = DEFAULT_CONFIG.copy()
                save_config(config)
                print(f"\n{ConsoleColor.green('[成功]')} 配置已重置为默认值！")
            else:
                print(f"\n{ConsoleColor.yellow('[取消]')} 已取消重置操作！")
            input("\n按回车继续...")
        elif choice == "0":
            break
        else:
            print(f"\n{ConsoleColor.red('[错误]')} 输入无效，请输入0-3之间的数字！")
            input("\n按回车重新选择...")

def main():
    config = load_config()
    
    global MOD_ROOT_DIR
    if not MOD_ROOT_DIR:
        MOD_ROOT_DIR = select_mod_path(config)
    
    init_global_paths(MOD_ROOT_DIR)
    
    handle_dependencies(config)
    
    while True:
        show_menu(config)
        choice = input("请选择功能（0-5）：").strip()
        
        if choice == "1":
            generate_dds_thumbnails(is_batch=False)
        elif choice == "2":
            register_background_database(is_batch=False)
        elif choice == "3":
            register_small_background_gfx(is_batch=False)
        elif choice == "4":
            clear_screen()
            print("="*60)
            print("                    执行全部功能")
            print("="*60)
            print("\n开始执行全部功能（自动执行，保留所有输出）...")
            print("-"*60)
            
            generate_dds_thumbnails(is_batch=True, batch_output=[])
            print("-"*60)
            register_background_database(is_batch=True, batch_output=[])
            print("-"*60)
            register_small_background_gfx(is_batch=True, batch_output=[])
            
            print("\n" + "="*60)
            print(f"{ConsoleColor.green('[完成]')} 全部功能执行完成！")
            input("\n按回车返回菜单...")
        elif choice == "5":
            modify_config(config)
        elif choice == "0":
            clear_screen()
            print(f"=== 钢铁雄心IV 加载图处理工具 {CODE_VERSION} | 作者：{AUTHOR} ===")
            print("\n程序退出，再见！")
            break
        else:
            clear_screen()
            print("="*60)
            print("                    输入错误")
            print("="*60)
            print(f"\n{ConsoleColor.red('[错误]')} 输入无效，请输入0-5之间的数字！")
            input("\n按回车重新选择...")

if __name__ == "__main__":
    main()