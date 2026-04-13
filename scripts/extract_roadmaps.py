import os
import json

base_path = r'c:\Users\91720\gecwp\student_app\roadmapsh\src\data\roadmaps'
output_path = r'c:\Users\91720\gecwp\student_app\assets\data\roadmaps_summary.json'

roadmaps_summary = []

if not os.path.exists(os.path.dirname(output_path)):
    os.makedirs(os.path.dirname(output_path))

for roadmap_id in os.listdir(base_path):
    roadmap_dir = os.path.join(base_path, roadmap_id)
    if os.path.isdir(roadmap_dir):
        json_file = os.path.join(roadmap_dir, f"{roadmap_id}.json")
        if os.path.exists(json_file):
            try:
                with open(json_file, 'r', encoding='utf-8') as f:
                    data = json.load(f)
                    nodes = data.get('nodes', [])
                    # Extract topics (types: 'topic', 'subtopic')
                    topics = []
                    for node in nodes:
                        label = node.get('data', {}).get('label', '')
                        node_type = node.get('type', '')
                        if label and node_type in ['topic', 'subtopic']:
                            topics.append({
                                'title': label,
                                'type': node_type
                            })
                    
                    roadmaps_summary.append({
                        'id': roadmap_id,
                        'name': roadmap_id.replace('-', ' ').title(),
                        'topics_count': len(topics),
                        'sample_topics': [t['title'] for t in topics[:5]]
                    })
            except Exception as e:
                print(f"Error processing {roadmap_id}: {e}")

with open(output_path, 'w', encoding='utf-8') as f:
    json.dump(roadmaps_summary, f, indent=2)

print(f"Generated summary for {len(roadmaps_summary)} roadmaps.")
