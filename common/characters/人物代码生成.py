import os
from datetime import datetime

def generate_character_code(country_key, character_key):
    """
    生成HOI4人物代码
    
    Args:
        country_key (str): 国家键值（如YUZ）
        character_key (str): 人物键值（如Yoshino）
    """
    
    full_key = f"{country_key}_{character_key}"
    portrait_large = f"GFX_{full_key}"
    portrait_small = f"GFX_idea_{full_key}"
    
    code_template = f"""{full_key} = {{
    name={full_key}
    portraits={{
        army={{
            large={portrait_large}
            small={portrait_small}
        }}
        civilian={{
            large={portrait_large}
            small={portrait_small}
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
    
    return code_template

def save_to_file(content, filename=None, folder="output"):
    """
    将内容保存到txt文件
    
    Args:
        content (str): 要保存的内容
        filename (str): 文件名，如果为None则自动生成
        folder (str): 保存文件夹
    """
    
    # 创建输出文件夹
    if not os.path.exists(folder):
        os.makedirs(folder)
    
    # 生成文件名
    if filename is None:
        timestamp = datetime.now().strftime("%Y%m%d_%H%M%S")
        filename = f"hoi4_characters_{timestamp}.txt"
    elif not filename.endswith('.txt'):
        filename += '.txt'
    
    # 完整文件路径
    filepath = os.path.join(folder, filename)
    
    # 写入文件
    try:
        with open(filepath, 'w', encoding='utf-8') as f:
            f.write(content)
        return filepath
    except Exception as e:
        print(f"保存文件时出错: {e}")
        return None

def single_character_mode():
    """
    单个人物生成模式
    """
    print("\n=== 单个人物生成模式 ===")
    country_key = input("请输入国家键值（如YUZ）: ").strip()
    character_key = input("请输入人物键值（如Chisaki）: ").strip()
    
    if not country_key or not character_key:
        print("错误：国家键值和人物键值不能为空！")
        return
    
    # 生成代码
    character_code = generate_character_code(country_key, character_key)
    
    # 输出结果
    print("\n生成的人物代码：")
    print(character_code)
    
    # 保存选项
    print("\n保存选项：")
    print("1. 保存到单独文件")
    print("2. 保存到汇总文件")
    print("3. 不保存")
    
    save_choice = input("请选择保存方式 (1/2/3): ").strip()
    
    if save_choice == "1":
        # 保存到单独文件
        filename = f"{country_key}_{character_key}.txt"
        filepath = save_to_file(character_code, filename)
        if filepath:
            print(f"✓ 代码已保存到: {filepath}")
    
    elif save_choice == "2":
        # 保存到汇总文件
        filename = input("请输入汇总文件名（不含后缀）: ").strip() or "hoi4_characters"
        filepath = save_to_file(character_code, filename)
        if filepath:
            print(f"✓ 代码已保存到汇总文件: {filepath}")
    
    return character_code

def batch_generate_mode():
    """
    批量生成模式
    """
    print("\n=== 批量人物生成模式 ===")
    print("请输入多组国家-人物键值对（输入空值结束）")
    
    characters = []
    all_codes = []
    
    while True:
        print(f"\n第 {len(characters) + 1} 个人物:")
        country_key = input("国家键值 (直接回车结束): ").strip()
        if not country_key:
            break
        
        character_key = input("人物键值: ").strip()
        if not character_key:
            break
        
        characters.append((country_key, character_key))
    
    if not characters:
        print("未输入任何有效数据！")
        return
    
    # 生成所有代码
    print(f"\n正在生成 {len(characters)} 个人物代码...")
    for i, (country_key, character_key) in enumerate(characters, 1):
        code = generate_character_code(country_key, character_key)
        all_codes.append(code)
        print(f"\n--- 人物 {i}: {country_key}_{character_key} ---")
        print(code)
    
    # 合并所有代码
    combined_code = "\n\n".join(all_codes)
    
    # 保存选项
    print(f"\n批量生成完成！共生成 {len(characters)} 个人物代码")
    print("保存选项：")
    print("1. 保存到单个文件（所有人物）")
    print("2. 分别保存到单独文件")
    print("3. 两者都保存")
    print("4. 不保存")
    
    save_choice = input("请选择保存方式 (1/2/3/4): ").strip()
    
    if save_choice in ["1", "3"]:
        # 保存到单个文件
        filename = input("请输入汇总文件名（不含后缀）: ").strip() or "hoi4_characters_batch"
        filepath = save_to_file(combined_code, filename)
        if filepath:
            print(f"✓ 所有人物代码已保存到: {filepath}")
    
    if save_choice in ["2", "3"]:
        # 分别保存到单独文件
        saved_count = 0
        for (country_key, character_key), code in zip(characters, all_codes):
            filename = f"{country_key}_{character_key}.txt"
            filepath = save_to_file(code, filename)
            if filepath:
                saved_count += 1
                print(f"✓ 已保存: {filename}")
        print(f"✓ 共保存了 {saved_count} 个单独文件")
    
    return combined_code

def view_saved_files():
    """
    查看已保存的文件
    """
    folder = "output"
    if not os.path.exists(folder):
        print("输出文件夹不存在，尚未保存任何文件。")
        return
    
    files = [f for f in os.listdir(folder) if f.endswith('.txt')]
    if not files:
        print("输出文件夹中没有txt文件。")
        return
    
    print(f"\n=== 已保存的文件（共 {len(files)} 个）===")
    for i, file in enumerate(sorted(files), 1):
        filepath = os.path.join(folder, file)
        file_size = os.path.getsize(filepath)
        print(f"{i}. {file} ({file_size} bytes)")

def main():
    """
    主函数
    """
    while True:
        print("\n" + "="*50)
        print("        HOI4人物代码生成器")
        print("="*50)
        print("1. 单个人物生成")
        print("2. 批量人物生成")
        print("3. 查看已保存的文件")
        print("4. 退出程序")
        
        choice = input("\n请选择功能 (1/2/3/4): ").strip()
        
        if choice == "1":
            single_character_mode()
        elif choice == "2":
            batch_generate_mode()
        elif choice == "3":
            view_saved_files()
        elif choice == "4":
            print("感谢使用HOI4人物代码生成器！")
            break
        else:
            print("无效选择，请重新输入！")
        
        input("\n按回车键继续...")

if __name__ == "__main__":
    main()