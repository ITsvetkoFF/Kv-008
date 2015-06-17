import json
from sqlalchemy import func

from api.v1_0.handlers.base import BaseHandler
from api.v1_0.models.detailed_problem import DetailedProblem


class AllProblemsHandler(BaseHandler):
    def get(self):
        all_problems = []

        for problem, point_json in self.sess.query(
                DetailedProblem, func.ST_AsGeoJSON(DetailedProblem.location)
        ):
            lat, lon = json.loads(point_json)['coordinates']
            all_problems.append(dict(
                id=problem.id,
                title=problem.title,
                status=problem.status,
                date=problem.date,
                problem_type_id=problem.problem_type_id,
                lat=lat,
                lon=lon
            ))

        json_string = json.dumps(all_problems, ensure_ascii=False)

        self.write(json_string)
