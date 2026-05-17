def generate_hoi4_event_code(event_number):
    return f"""country_event = {{#
    id = SKR.{event_number}
    title = SKR.{event_number}.t
    desc = SKR.{event_number}.desc
    #picture = GFX_event_SKR_{event_number}
    is_triggered_only = yes
    fire_only_once = yes

    option = {{
        name = SKR.{event_number}.a

        ai_chance = {{
            base = 10
        }}
    }}
}}"""
#文本自己改
def generate_localization(event_number):
    return f""" SKR.{event_number}.t: ""
 SKR.{event_number}.desc: ""
 SKR.{event_number}.a: ""
"""
#文本自己改
def generate_hoi4_news_event_code(event_number):
    return f"""news_event = {{#
    id = SKR_news.{event_number}
    title = SKR_news.{event_number}.t
    desc = SKR_news.{event_number}.desc
    #picture = GFX_SKR_news_{event_number}
    is_triggered_only = yes
	major = yes

    option = {{
        name = SKR_news.{event_number}.a

        ai_chance = {{
            base = 10
        }}
    }}
}}"""
#文本自己改
def generate_news_event_localization(event_number):
    return f""" SKR_news.{event_number}.t: ""
 SKR_news.{event_number}.desc: ""
 SKR_news.{event_number}.a: ""
"""
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
            elif mode == "3":
                content += generate_hoi4_news_event_code(i) + "\n\n"
            elif mode == "4":
                content += generate_news_event_localization(i)
        
        return content
    except ValueError:
        print("请输入有效的数字！")
        return ""

def main():
    print("请选择生成模式：")
    print("1 - 生成事件代码")
    print("2 - 生成事件本地化")
    print("3 - 生成新闻事件代码")
    print("4 - 生成新闻事件本地化")
    mode = input("请输入模式编号(1/2/3/4): ")
    
    if mode not in ["1", "2", "3", "4"]:
        print("无效的模式选择！")
        return
    
    min_event = input("请输入最小事件编号: ")
    max_event = input("请输入最大事件编号: ")
    
    content = generate_content(mode, min_event, max_event)
    if not content:
        return
    
    if mode == "1":
        output_filename = f"SKR_events_{min_event}_to_{max_event}.txt"
    elif mode == "3":
        output_filename = f"SKR_news_events_{min_event}_to_{max_event}.txt"
    else:
        output_filename = f"SKR_localization_{min_event}_to_{max_event}.yml"
    
    with open(output_filename, "w", encoding="utf-8") as file:
        file.write(content)
    
    print(f"成功生成文件：{output_filename}")

if __name__ == "__main__":
    main()