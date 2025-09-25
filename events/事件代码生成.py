def generate_hoi4_event_code(event_number):
    return f"""country_event = {{#
    id = USF_temp.{event_number}
    title = USF_temp.{event_number}.t
    desc = USF_temp.{event_number}.desc
    #picture = GFX_event_USF_{event_number}
    is_triggered_only = yes
    fire_only_once = yes

    option = {{
        name = USF_temp.{event_number}.a

        ai_chance = {{
            base = 10
        }}
    }}
}}"""
#文本自己改
def generate_localization(event_number):
    return f""" USF.{event_number}.t: ""
 USF.{event_number}.desc: ""
 USF.{event_number}.a: ""
"""
#文本自己改
def generate_content(mode, min_event_num, max_event_num):
    try:
        max_event_num = int(max_event_num)
        min_event_num = int(min_event_num)
        if max_event_num < min_event_num:
            print("最大事件编号不能小于最小事件编号！")
            return ""
        
        content = ""
        for i in range(min_event_num, max_event_num + 1):
            if mode == "1":
                content += generate_hoi4_event_code(i) + "\n\n"
            elif mode == "2":
                content += generate_localization(i)
        
        return content
    except ValueError:
        print("请输入有效的数字！")
        return ""

def main():
    print("请选择生成模式：")
    print("1 - 生成事件代码")
    print("2 - 生成事件本地化")
    mode = input("请输入模式编号(1/2): ")
    
    if mode not in ["1", "2"]:
        print("无效的模式选择！")
        return
    
    min_event = input("请输入最小事件编号: ")
    max_event = input("请输入最大事件编号: ")
    
    content = generate_content(mode, min_event, max_event)
    if not content:
        return
    
    if mode == "1":
        output_filename = f"USF_events_{min_event}_to_{max_event}.txt"
    else:
        output_filename = f"USF_localization_{min_event}_to_{max_event}.yml"
    
    with open(output_filename, "w", encoding="utf-8") as file:
        file.write(content)
    
    print(f"成功生成文件：{output_filename}")

if __name__ == "__main__":
    main()