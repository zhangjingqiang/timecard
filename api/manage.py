from flask.cli import FlaskGroup

from timecard import app, db, Timecard

cli = FlaskGroup(app)


@cli.command("create_db")
def create_db():
    db.drop_all()
    db.create_all()
    db.session.commit()


@cli.command("seed_db")
def seed_db():
    db.session.add(
        Timecard(
            date="5/30",
            start="9:00",
            end="18:00",
            rest="1:00",
            note="Good day"))
    db.session.commit()


if __name__ == "__main__":
    cli()
