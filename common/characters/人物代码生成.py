import os
from datetime import datetime

def generate_all_codes(country_key, character_key):
    """
    一次性生成所有类型的代码
    """
    full_key = f"{country_key}_{character_key}"
    
    # 1. 生成人物代码
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
    corps_commander = {{
        traits = {{}}
        skill=1
        attack_skill=1
        defense_skill=1
        planning_skill=1
        logistics_skill=1
        legacy_id=-1
    }}
}}"""
    
    # 2. 生成本地化代码
    localization_code = f' {full_key}: ""'
    
    # 3. 生成GFX注册代码
    gfx_code = f"""SpriteType = {{
    name = "GFX_{full_key}"
    texturefile = "gfx/leaders/{country_key}/{full_key}.dds"
    legacy_lazy_load = no
}}


SpriteType = {{
    name = "GFX_idea_{full_key}"
    texturefile = "gfx/interface/ideas/{country_key}/{full_key}.dds"
}}"""
    
    return character_code, localization_code, gfx_code

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
    """
    单个人物生成模式
    """
    print("\n" + "="*60)
    print("          单个人物生成模式")
    print("="*60)
    
    while True:
        print("\n请输入人物信息（输入空值返回主菜单）:")
        country_key = input("国家键值: ").strip()
        if not country_key:
            return
            
        character_key = input("人物键值: ").strip()
        if not character_key:
            return
        
        print(f"\n正在为 {country_key}_{character_key} 生成所有代码...")
        
        # 生成所有代码
        character_code, localization_code, gfx_code = generate_all_codes(country_key, character_key)
        
        # 显示所有生成的代码
        print("\n" + "="*60)
        print("生成的人物代码：")
        print(character_code)
        
        print("\n" + "="*60)
        print("生成的本地化代码：")
        print(localization_code)
        
        print("\n" + "="*60)
        print("生成的GFX注册代码：")
        print(gfx_code)
        
        # 自动保存所有文件
        print("\n" + "="*60)
        print("正在自动保存文件...")
        
        # 保存人物代码
        save_to_file(character_code, f"{country_key}_{character_key}_character.txt")
        print("✓ 人物代码已保存")
        
        # 保存本地化代码
        save_to_file(localization_code, f"{country_key}_{character_key}_localization.txt")
        print("✓ 本地化代码已保存")
        
        # 保存GFX代码
        save_to_file(gfx_code, f"{country_key}_{character_key}_gfx.txt")
        print("✓ GFX代码已保存")
        
        # 保存合并文件
        combined_content = f"""=== HOI4人物全代码 ===
生成时间: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
人物: {country_key}_{character_key}

=== 1. 人物代码 ===
{character_code}

=== 2. 本地化代码 ===
{localization_code}

=== 3. GFX注册代码 ===
{gfx_code}"""
        
        save_to_file(combined_content, f"{country_key}_{character_key}_all_codes.txt")
        print("✓ 合并文件已保存")
        
        print(f"\n✓ 所有代码生成完成！文件保存在 output/ 文件夹")
        print("\n" + "="*60)

def batch_mode():
    """
    批量人物生成模式
    """
    print("\n" + "="*60)
    print("          批量人物生成模式")
    print("="*60)
    
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
            country_key = parts[0]
            character_key = parts[1]
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
    
    # 存储所有生成的代码
    all_character_codes = []
    all_localization_codes = []
    all_gfx_codes = []
    
    # 为每个人物生成代码
    for i, (country_key, character_key) in enumerate(characters, 1):
        print(f"正在生成第 {i}/{len(characters)} 个人物: {country_key}_{character_key}")
        
        character_code, localization_code, gfx_code = generate_all_codes(country_key, character_key)
        
        all_character_codes.append(character_code)
        all_localization_codes.append(localization_code)
        all_gfx_codes.append(gfx_code)
        
        # 为每个人物保存单独文件
        save_to_file(character_code, f"{country_key}_{character_key}_character.txt")
        save_to_file(localization_code, f"{country_key}_{character_key}_localization.txt")
        save_to_file(gfx_code, f"{country_key}_{character_key}_gfx.txt")
        
        # 保存合并文件
        combined_content = f"""=== HOI4人物全代码 ===
生成时间: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
人物: {country_key}_{character_key}

=== 1. 人物代码 ===
{character_code}

=== 2. 本地化代码 ===
{localization_code}

=== 3. GFX注册代码 ===
{gfx_code}"""
        
        save_to_file(combined_content, f"{country_key}_{character_key}_all_codes.txt")
    
    print("\n" + "="*60)
    print("正在生成批量汇总文件...")
    
    # 生成时间戳
    timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
    
    # 1. 批量人物代码文件
    batch_character_content = "\n\n".join(all_character_codes)
    batch_character_file = f"batch_characters_{timestamp}.txt"
    save_to_file(batch_character_content, batch_character_file)
    print(f"✓ 批量人物代码: {batch_character_file}")
    
    # 2. 批量本地化文件
    batch_localization_content = "\n".join(all_localization_codes)
    batch_localization_file = f"batch_localization_{timestamp}.txt"
    save_to_file(batch_localization_content, batch_localization_file)
    print(f"✓ 批量本地化代码: {batch_localization_file}")
    
    # 3. 批量GFX文件
    batch_gfx_content = "\n\n".join(all_gfx_codes)
    batch_gfx_file = f"batch_gfx_{timestamp}.txt"
    save_to_file(batch_gfx_content, batch_gfx_file)
    print(f"✓ 批量GFX代码: {batch_gfx_file}")
    
    # 4. 生成报告文件
    report_content = f"""HOI4人物代码批量生成报告
================================
生成时间: {datetime.now().strftime('%Y-%m-%d %H:%M:%S')}
生成数量: {len(characters)} 个人物

人物列表:
"""
    for i, (country_key, character_key) in enumerate(characters, 1):
        report_content += f"{i:2d}. {country_key}_{character_key}\n"
    
    report_content += f"""
生成的文件:
1. {batch_character_file} - 所有人物代码
2. {batch_localization_file} - 所有本地化代码  
3. {batch_gfx_file} - 所有GFX注册代码

此外，每个人物都有单独的4个文件:
- 国家_人物_character.txt
- 国家_人物_localization.txt  
- 国家_人物_gfx.txt
- 国家_人物_all_codes.txt
"""
    
    report_file = f"batch_report_{timestamp}.txt"
    save_to_file(report_content, report_file)
    print(f"✓ 批量生成报告: {report_file}")
    
    print("\n" + "="*60)
    print("🎉 批量生成完成！")
    print(f"✓ 共生成 {len(characters)} 个人物的所有代码")
    print(f"✓ 生成 {len(characters) * 4} 个单独文件")
    print(f"✓ 生成 4 个批量汇总文件")
    print(f"✓ 生成 1 个报告文件")
    print(f"✓ 总计: {len(characters) * 4 + 5} 个文件")
    print(f"✓ 所有文件保存在 output/ 文件夹")
    print("="*60)

def main():
    """
    主函数
    """
    while True:
        print("\n" + "="*60)
        print("          HOI4人物代码生成器")
        print("="*60)
        print("1. 单个人物生成")
        print("2. 批量人物生成")
        print("3. 退出程序")
        
        choice = input("\n请选择模式 (1/2/3): ").strip()
        
        if choice == "1":
            single_mode()
        elif choice == "2":
            batch_mode()
        elif choice == "3":
            print("感谢使用HOI4人物代码生成器！")
            break
        else:
            print("❌ 无效选择，请重新输入！")
        
        input("\n按回车键继续...")

if __name__ == "__main__":
    main()