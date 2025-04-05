package exceptions

import "fmt"

type missingRequiredValueException struct {
	msg string
}

func (exception *missingRequiredValueException) Error() string {
	return fmt.Sprintf("Missing required value. %s", exception.msg)
}

func MissingRequiredValue(msg string) *missingRequiredValueException {
	return &missingRequiredValueException{msg}
}
