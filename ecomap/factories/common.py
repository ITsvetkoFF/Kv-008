from sqlalchemy import orm

# This is a common session for all the factories.
# You should configure it later, binding an engine.
Session = orm.scoped_session(orm.sessionmaker())
