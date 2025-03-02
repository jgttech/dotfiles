package file

import (
	"io"
	"jgttech/dotfiles/src/assert"
	"jgttech/dotfiles/src/exceptions"
	_os "jgttech/dotfiles/src/os"
	"os"
)

func Copy(from, to string) (int64, error) {
	if !_os.Exists(from) {
		return 0, exceptions.FileNotFound(from)
	}

	var toFile *os.File
	defer toFile.Close()

	if _os.Exists(to) {
		toFile = assert.Must(os.Open(to))
	} else {
		toFile = assert.Must(os.Create(to))
	}

	fromStat := assert.Must(os.Stat(from))
	fromFile := assert.Must(os.Open(from))
	defer fromFile.Close()

	bytes, err := io.CopyN(toFile, fromFile, fromStat.Size())

	if err != nil {
		return 0, err
	}

	return bytes, nil
}
