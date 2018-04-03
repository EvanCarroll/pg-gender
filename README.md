pg-gender
====

A progressive and inclusive model for gender in the database.
best.

Description
----

An implementation of a three dimensional type, gender. [This
model](https://www.genderspectrum.org/quick-links/understanding-gender/) comes
from gender-spectrum.org which breaks down gender into

* **Body** - *"our body, our experience of our own body, how society genders
bodies, and how others interact with us based on our body."*

* **Identity** - *"our deeply held, internal sense of self as male, female, a
blend of both, or neither; who we internally know ourselves to be."*

* **Expression** - *"how we present our gender in the world and how society,
culture, community, and family perceive, interact with, and try to shape our
gender. Gender expression is also related to gender roles and how society uses
those roles to try to enforce conformity to current gender norms."*

A user interface for this will require something like three sliders (for the
three axis dimensionality), or a 3d picker.

Internally, each axis is stored as a `float`. On one side of the axis, we have
"female" which is represented as `1`, and on the other side we have "male"
which is represented as `-1`. The full range between `[-1,1]` can be used to
represented the spectrum of each attribute. `0` represents known values.

Synopsis
----

	## Known to not identify with a gender
	SELECT gender.mk_gender(0,0,0);

	## Unknown gender
	SELECT undef::gender;

	## Show the 3d gender (text-represetnation)
	## And, the 2d-body, 2d-expression, and 2d-identity (text-representation)
	SELECT gender,
		gender.body(gender),
		gender.expression(gender),
		gender.identity(gender)
	FROM persons;

	## Index it, and find those who identify in a similar fashion with KNN
	CREATE INDEX ON persons
		USING gist (gender);

	## You may want null::gender
	SELECT gender.polar_male();   ## Male   = mk_gender(-1,-1,-1)
	SELECT gender.polar_female(); ## Female = mk_gender( 1, 1, 1)


	## Should return all gender-possibilities
	SELECT gender
	FROM table
	WHERE gender BETWEEN gender.polar_male() AND gender.polar_female();

Background
----

Gender is tricky. We can all agree there are more than two genders, and this is
a serious attempt to model something more sophesticated in the database than
currently available. **When standards like [IEC 5218](https://en.wikipedia.org/wiki/ISO/IEC_5218) are so flagrantly reactionary, we have an obligation not to follow them.**

Caveat
----

Transphobia and alphabet soup jokes are not welcome.
