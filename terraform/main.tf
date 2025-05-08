---
- name: Configure frontend servers
  hosts: frontend
  become: yes
  vars:
    backend_server: "{{ hostvars[groups['backend'][0]]['ansible_host'] }}"
  tasks:
    - name: Update all packages
      dnf:
        name: '*'
        state: latest

    - name: Install NGINX
      dnf:
        name: nginx
        state: present

    - name: Configure NGINX proxy
      template:
        src: ./nginx.conf
        dest: /etc/nginx/nginx.conf
      notify: restart nginx

  handlers:
    - name: restart nginx
      service:
        name: nginx
        state: restarted
