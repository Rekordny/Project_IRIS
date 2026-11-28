import os
from datetime import datetime

SEPARATOR = "\n" + "=" * 60 + "\n"

def generate_all_codes(country_key, character_key):
    """一次性生成所有类型的代码"""
    full_key = f"{country_key}_{character_key}"

    character_code = f"""{full_key} = {{
    name={full_key}
    portraits={{
        army={{
            large=GFX_{full_key}
            small=GFX_idea_{full_key}
        }}
        civilian={{
            large=GFX_{full_key}
            small=GFX_idea_{full_key}
        }}
    }}
}}"""

    localization_code = f' {full_key}: ""'

    gfx_code = f"""    SpriteType = {{
        name = "GFX_{full_key}"
        texturefile = "gfx/leaders/{country_key}/{full_key}.dds"
        legacy_lazy_load = no
    }}

    SpriteType = {{
        name = "GFX_idea_{full_key}"
        texturefile = "gfx/interface/ideas/{country_key}/idea_{full_key}.dds"
    }}"""

    recruit_code = f' recruit_character = {full_key}'

    return character_code, localization_code, gfx_code, recruit_code


def generate_spirit_codes(country_key, spirit_key):
    """生成国家精神：精神代码、本地化、GFX注册"""
    full_key = f"{country_key}_{spirit_key}"

    spirit_localization = f""" {full_key}: ""
 {full_key}_desc: \"\""""

    spirit_gfx = f"""    SpriteType = {{
        name = "GFX_idea_{full_key}"
        texturefile = "gfx/interface/ideas/{country_key}/{full_key}.dds"
    }}"""

    # 精神定义本身（用于 ideas 文件）
    spirit_idea = f"""    {full_key} = {{
        picture = GFX_idea_{full_key}
    }}"""

    return spirit_localization, spirit_gfx, spirit_idea


def save_to_file(content, filename, folder="output"):
    """保存内容到文件"""
    if not os.path.exists(folder):
        os.makedirs(folder)
    if not filename.endswith('.txt'):
        filename += '.txt'
    filepath = os.path.join(folder, filename)
    try:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        return filepath
    except Exception as e:
        print(f"保存文件时出错: {e}")
        return None


def single_mode():
    """单个人物生成模式"""
    print(SEPARATOR + "          单个人物生成模式" + SEPARATOR)

    while True:
        print("\n请输入人物信息（输入空值返回主菜单）:")
        country_key = input("国家键值: ").strip()
        if not country_key:
            return
        character_key = input("人物键值: ").strip()
        if not character_key:
            return

        print(f"\n正在为 {country_key}_{character_key} 生成所有代码...")
        character_code, localization_code, gfx_code, recruit_code = generate_all_codes(
            country_key, character_key)

        full_key = f"{country_key}_{character_key}"

        # 合并文件（1个主文件，含所有内容）
        combined_content = f"""=== HOI4人物全代码 ===
生成时间: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
人物: {full_key}

=== 1. 人物代码 ===
{character_code}

=== 2. 本地化代码 ===
{localization_code}

=== 3. GFX注册代码 ===
{gfx_code}

=== 4. 招募代码 ===
{recruit_code}"""

        save_to_file(combined_content, f"{full_key}_all_codes.txt")
        print(f"\n✓ 已保存: {full_key}_all_codes.txt")
        print(f"✓ 所有代码生成完成！文件保存在 output/ 文件夹")
        print(SEPARATOR)


def batch_mode():
    """批量人物生成模式"""
    print(SEPARATOR + "          批量人物生成模式" + SEPARATOR)

    print("\n请输入多个人物信息（每行一个，格式：国家键值 人物键值）")
    print("示例: YUZ Chisaki")
    print("输入空行结束输入")
    print("-" * 40)

    characters = []
    line_count = 0

    while True:
        line_count += 1
        input_line = input(f"人物 {line_count}: ").strip()
        if not input_line:
            break
        parts = input_line.split()
        if len(parts) >= 2:
            country_key, character_key = parts[0], parts[1]
            characters.append((country_key, character_key))
            print(f"✓ 已添加: {country_key}_{character_key}")
        else:
            print("❌ 格式错误，请按 '国家键值 人物键值' 格式输入")
            line_count -= 1

    if not characters:
        print("❌ 未输入任何人物信息！")
        return

    print(f"\n开始为 {len(characters)} 个人物生成所有代码...")
    print("-" * 40)

    all_character_codes = []
    all_localization_codes = []
    all_gfx_codes = []
    all_recruit_codes = []

    for i, (country_key, character_key) in enumerate(characters, 1):
        full_key = f"{country_key}_{character_key}"
        print(f"正在生成第 {i}/{len(characters)} 个人物: {full_key}")

        character_code, localization_code, gfx_code, recruit_code = generate_all_codes(
            country_key, character_key)

        all_character_codes.append(character_code)
        all_localization_codes.append(localization_code)
        all_gfx_codes.append(gfx_code)
        all_recruit_codes.append(recruit_code)

    # 生成时间戳
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")

    # 只生成 1 个汇总文件（所有内容合并）
    batch_content = f"""HOI4人物代码批量生成报告
================================
生成时间: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
生成数量: {len(characters)} 个人物

人物列表:
"""
    for i, (country_key, character_key) in enumerate(characters, 1):
        batch_content += f"{i:2d}. {country_key}_{character_key}\n"

    batch_content += "\n\n=== 1. 人物代码 ===\n" + "\n\n".join(all_character_codes)
    batch_content += "\n\n=== 2. 本地化代码 ===\n" + "\n".join(all_localization_codes)
    batch_content += "\n\n=== 3. GFX注册代码 ===\n" + "\n\n".join(all_gfx_codes)
    batch_content += "\n\n=== 4. 招募代码 ===\n" + "\n".join(all_recruit_codes)

    batch_file = f"batch_all_{timestamp}.txt"
    save_to_file(batch_content, batch_file)

    print(SEPARATOR)
    print("🎉 批量生成完成！")
    print(f"✓ 共生成 {len(characters)} 个人物的所有代码")
    print(f"✓ 全部合并保存在: {batch_file}")
    print(f"✓ 所有文件保存在 output/ 文件夹")
    print(SEPARATOR)


def spirit_mode():
    """国家精神生成模式"""
    print(SEPARATOR + "          国家精神生成模式" + SEPARATOR)
    print("\n说明：生成精神定义、desc本地化、GFX注册代码")
    print("输入空值返回主菜单\n")

    spirits = []
    line_count = 0

    while True:
        line_count += 1
        input_line = input(f"精神 {line_count}（格式：国家键值 精神键值）: ").strip()
        if not input_line:
            break
        parts = input_line.split()
        if len(parts) >= 2:
            country_key, spirit_key = parts[0], parts[1]
            spirits.append((country_key, spirit_key))
            print(f"✓ 已添加: {country_key}_{spirit_key}")
        else:
            print("❌ 格式错误，请按 '国家键值 精神键值' 格式输入")
            line_count -= 1

    if not spirits:
        print("❌ 未输入任何精神信息！")
        return

    print(f"\n正在为 {len(spirits)} 个精神生成代码...")
    print("-" * 40)

    all_localization = []
    all_gfx = []
    all_ideas = []

    for country_key, spirit_key in spirits:
        full_key = f"{country_key}_{spirit_key}"
        print(f"✓ 生成: {full_key}")
        loc, gfx, idea = generate_spirit_codes(country_key, spirit_key)
        all_localization.append(loc)
        all_gfx.append(gfx)
        all_ideas.append(idea)

    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    content = f"""=== HOI4国家精神代码 ===
生成时间: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
数量: {len(spirits)}

精神列表:
"""
    for i, (c, s) in enumerate(spirits, 1):
        content += f"{i:2d}. {c}_{s}\n"

    content += "\n\n=== 1. 精神定义（放入 ideas 文件） ===\n" + "\n\n".join(all_ideas)
    content += "\n\n=== 2. 本地化代码 ===\n" + "\n".join(all_localization)
    content += "\n\n=== 3. GFX注册代码 ===\n" + "\n\n".join(all_gfx)

    file_name = f"spirits_{timestamp}.txt"
    save_to_file(content, file_name)
    print(f"\n✓ 已保存: {file_name}")
    print(SEPARATOR)


def main():
    while True:
        print(SEPARATOR + "          HOI4代码生成器" + SEPARATOR)
        print("1. 单个人物生成")
        print("2. 批量人物生成")
        print("3. 退出程序")
        print("4. 国家精神生成")

        choice = input("\n请选择模式 (1/2/3/4): ").strip()

        if choice == "1":
            single_mode()
        elif choice == "2":
            batch_mode()
        elif choice == "3":
            print("感谢使用HOI4代码生成器！")
            break
        elif choice == "4":
            spirit_mode()
        else:
            print("❌ 无效选择，请重新输入！")

        input("\n按回车键继续...")


if __name__ == "__main__":
    main()