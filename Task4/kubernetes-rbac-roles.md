| Роль | Права роли | Группы пользователей |
| --- | --- | --- |
| viewer | Просмотр основных ресурсов кластера: pods, logs, services, configmaps, deployments, ingresses, networkpolicies. Без доступа к secrets и без права изменять ресурсы. | Бизнес-аналитики, владельцы продуктов и менеджеры операционных команд (`viewer`). |
| editor | Просмотр и настройка рабочих ресурсов: pods, services, configmaps, deployments, statefulsets, daemonsets, jobs, ingresses, networkpolicies. Без доступа к secrets и без управления RBAC. | DevOps-инженеры и инженеры эксплуатации продуктовых команд (`editor`). |
| admin | Администрирование ресурсов Kubernetes, включая secrets, роли и привязки ролей. | Специалист по ИБ и администраторы платформы (`admin`). |