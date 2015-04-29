##Основные компоненты tornado:
  * веб-фреймворк (RequestHandler, который наследуется для создания веб-приложений, а также вспомогательные классы)
  * реализации клиентской и серверной части HTTP (HTTPServer and AsyncHTTPClient)
  * асинхронная сетевая библиотека (IOLoop and IOStream), которая служит основным строительным блоком HTTP компонент и может быть использована
  для реализации других протоколов
  * библиотека coroutine (tornado.gen), с помощью которой можно писать асинхронный код проще и понятнее, чем используя цепочки кол-бэков

Торнадо фреймворк и HTTP server -- это альтернатива WSGI

Real-time web штукам нужно долгоживущее, почти всегда холостое соединение с пользователем. 
Синхронный веб-сервер для такого просто каждому пользователю предоставляет один поток выполнения.

Чтобы минимизировать издержки одновременных соединений, Торнадо использует однопоточный event loop. Весь код должен быть асинхронным и
неблокирующим, так как может быть активна только одна операция в каждый момент времени.

Блокирующая функция -- ждем чего-то перед тем, как вернуть контроль вызвавшей программе.

Асинхронная функция -- возвращает контроль до того, как закончилось ее выполнений, запуская какую-то фоновую работу, а потом в будущем
запускает какое-то действие в будущем (обычная функция делает все, что нада, и возвращает контроль)


##Структура веб-приложения

  RequestHandler subclasses
  
  Каждый обработчик определяет методы get(), post() etc.,которые будут вызваны в соответствии с методом запроса.
  Аргументы -- выцепленные группы в регулярных выражениях.
  RequestHandler.render or RequestHandler.write -- методы для создания ответа.
  * render() загружает Template и передает его, заполнив полученными аргументами.
  * write() используется для не-шаблонного вывода, принимает строки, байтсы и словари, которые будут закодированы в JSON.
  
  множество методов RequestHandler спроектированы, чтобы переопределить их в подклассах и использовать в приложении.
  чaсто определяют класс BaseHandler, который переопределяет методы write_error and get_current_user, и дальше уже наследуют свои обработчики от него
  объект обработчика имеет доступ к текущему запросу self.request (see HTTPServerRequest)
  данные запроса из HTML форм доступны через методы get_query_argument and get_body_argument
  если вместо form-encoding я хочу использовать JSON, тогда мне надо переопределять метод prepare обработчика

###ЗАПРОС
  каждый запрос порождает следующую цепочку вызовов:
  
  1. создается экземпляр RequestHandler
  2. вызывается initialize() (сохраняет полученные аргументы в атрибуты экземпляра) с аргументами инициализации из настроек Application
  3. prepare() -- вызывается для запроса с любым HTTP методом, удобно переопределить в суперклассе. Если в нем вызывается либо finish(), redirect(), тогда процесс останавливается здесь
  4. вызывается соответствующий метод
  5. когда запрос обработан, вызвается on_finish(). Для синхронных обработчиков это происходит сразу после возврата из get() к примеру, для асинхронных -- после вызова finish()

####Error Handling, Redirection, Asynchronous Handlers
  Application object -- перенаправляет входящие запросы обработчикам
      отвечает за все глобальные настройки приложения
      содержит таблицу путей, которая сопоставляет запросам обработчики
          таблица путей -- это список объектов URLSpec (tuples = a regexp and a handler class)
              если в регулярном выражении есть выцепленые группы, тогда эти группы будут переданы HTTP методу обработчика
              если третим аргументом объекту URLSpec передается словарь, тогда он содержит аргументы инициализации, которые буду
                  переданы RequestHandler.initialize
              URLSpec может иметь имя, которое можно будет использовать в RequestHandler.reverse_url
      конструктору Application можно передавать множество именованый аргументов чтобы настроить приложение и включить дополнительные штуки (см. Application.settings)

    main() -- запуск сервера

###User authentication
  set_secure_cookie, get_secure_cookie (в Application нужно указать дополнительный именованный аргумент cookie_secret). 
  Signed cookies содержат закодированное значение, метку времени и HMAC подпись. Если куки устрарело, или не совпадает подпись, тогда get_secure_cookie вернет None.
  Автентифицированный пользователь доступен в каждом обработчике запроса self.current_user и в каждом шаблоне как current_user (default current_user is None)
  
  Чтобы реализовать проверку подленности пользователя, нужно переопределить метод get_current_user() в обработчике запроса, чтобы определять
  текущего пользователя по, скажем, значению cookie

  Можно также использовать декоратор tornado.web.authenticated(это просто альтернатива проверке self.current_user --> self.redirect). 
  Если запрос попадает в сдекорированный метод, и пользователь не залогинен,
  тогда он будет перенаправлен на login_url -- еще одна настройка Application.


###Running and deploying
торнадо предоставляет свой собственный HTTPServer
main() запускает сервер


###Request handlers
1. создается экземпляр обработчика
2. вызывается метод initialize(), который присоединяет атрибуты к экземпляру
    атрибути задаем третим элементом (словарем) в URLSpec (например, атрибут database)
```python
    class ProfileHandler(RequestHandler):
        def initialize(self, database):
            self.database = database

        def get(self, username):
            ...

    app = Application([(r'/user/(.*)', ProfileHandler, dict(database=database))])
```
3. вызывается метод prepare() (перед вызовом методов get(), post() etc.) -- переопределяем его для общей инициализации (независимо
    от метода, который будет вызван в дальнейшем).
4. on_finish() -- вызывается по окончании запроса (ответ уже отправлен клиенту), для cleanup, logging

INPUT
RequestHandler.get_argument() --> unicode string
RequestHandler.get_query_argument()
RequestHandler.get_body_argument()
RequestHandler.request -- tornado.httputils.HTTPServerRequest object
RequestHandler.path_args -- содержит аргументы, который будут переданы HTTP verb методам (можно использовать в prepare())

OUTPUT
write() (записать вывод в буфер)-- если передаем сюда словарь, тогда он будет закодиров в JSON и будет добавлен хедер application/json
flush() -- вытолкнуть буфер в сеть
finish() -- закончить соединение
render() -- предоставить заполненый шаблон
redirect()
send_error() -- если буфер еще не вытолкнут в сеть, тогда этот метод сработает
application -- ссылка на объект Application
current_user -- автентифицированный пользователь по этому запросу -- кэшированная версия get_current_user()


###Application configuration
экземпляр этого класса передается httpserver.HTTPServer
отвечает за глобальные настройки приложения
содержит таблицу путей -- сопоставляет запросам обработчики

  когда прилетает запрос, мы идем по списку и ищем совпадение по регулярному выражение, а затем инстанциируем класс обработчика
  если передать в кортеж (URLSpec) третим аргументом словарь, он будет использовать для инициализации экземпляра обработчика (initialize())
    application = web.Application([(r"/static/(.*)", web.StaticFileHandler, {"path": "/var/www"})])
    можно также передать путь к папке статиков именованным аргументом при вызове Application
    
settings -- словарь настроек приложения

listen() -- запустить HTTPServer для нашего приложения на заданном порту (это альтернатива созданию экземпляра HTTPServer и вызова его метода listen)
IOLoop.instance().start() -- запускаем сервер

reverse_url(name, *args) --> URL path for the handler named name (handler must be an URLSpec instance) args -- вместо выцепленных групп в регулярном выражении
log_request(handler) -- записываем обработанный запрос в журнал


###Non-blocking HTTP server (single-threaded)
Обычно приложения мало взаимодействуют напрямую с этим классом, помимо запуска сервера в начале процесса.
Три варианта инициализации HTTPServer:
```python
1. listen -- simple single process
    server = HTTPServer(app)
    server.listen(8888)
    IOLoop.instance().start()
2. bind / start -- simple multi-process
    server = HTTPServer(app)
    server.bind(8888)
    server.start(0)  # Forks multiple sub-processes
    IOLoop.instance().start()
3. add_sockets -- advanced multi-process
```

v1_0/handlers

oauth.py
[hueniverse.com/oauth](http://hueniverse.com/oauth/) --

  For example, a web user (resource owner) can grant a printing service (client) access to her private
  photos stored at a photo sharing service (server), without sharing her username and password with the printing service.  Instead,
  she authenticates directly with the photo sharing service which issues the printing service delegation-specific credentials.
  
[habrahabr.ru/company/mailru/blog/115163](http://habrahabr.ru/company/mailru/blog/115163/) --

  OAuth 2.0 — протокол авторизации, позволяющий выдать одному сервису (приложению) права на доступ к ресурсам пользователя на другом
  сервисе. Протокол избавляет от необходимости доверять приложению логин и пароль, а также позволяет выдавать ограниченный набор прав,
  а не все сразу.

