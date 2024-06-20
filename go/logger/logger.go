package logger

import (
	"challenge-flutter-go/database"
	"challenge-flutter-go/models"
	"log"
	"os"
	"sync"
	"time"

	"gorm.io/gorm"
)

type Logger struct {
	database       *gorm.DB
	fileLogger     *log.Logger
	terminalLogger *log.Logger
	logFile        *os.File
	currentLogDate string
	logFilePath    string
	mutex          sync.Mutex
}

type additionalLogInfo struct {
	Ip              string
	Path            string
	Method          string
	Username        string
	EnrichedMessage string
}

var (
	logger *Logger
	once   sync.Once
)

func init() {
	once.Do(func() {
		var err error
		logger, err = newLogger()
		if err != nil {
			panic(err)
		}
	})
}

func newLogger() (logger *Logger, err error) {
	terminalLogger := log.New(os.Stdout, "", log.LstdFlags)

	logger = &Logger{
		database:       database.GetInstance(),
		terminalLogger: terminalLogger,
		logFilePath:    "logs/api",
	}
	err = logger.initFileLogger()
	if err != nil {
		return nil, err
	}

	return
}

func (l *Logger) initFileLogger() error {
	l.mutex.Lock()
	defer l.mutex.Unlock()

	if l.logFile != nil {
		l.logFile.Close()
	}

	currentDate := time.Now().Format("2006-01-02")
	l.currentLogDate = currentDate
	logFileName := l.logFilePath + "-" + currentDate + ".txt"

	// Ouvrir un nouveau fichier de log
	logFile, err := os.OpenFile(logFileName, os.O_APPEND|os.O_CREATE|os.O_WRONLY, 0666)
	if err != nil {
		return err
	}
	l.logFile = logFile
	l.fileLogger = log.New(logFile, "", log.LstdFlags)

	return nil
}

func (l *Logger) Close() error {
	return l.logFile.Close()
}

func (l *Logger) writeLog(level models.LogLevel, message string, additionalLogInfo *additionalLogInfo) {
	l.checkDateChange()

	logEntry := models.LogEntry{
		Level:   level,
		Message: message,
	}

	if additionalLogInfo != nil {
		logEntry.Ip = additionalLogInfo.Ip
		logEntry.Path = additionalLogInfo.Path
		logEntry.Method = additionalLogInfo.Method
		logEntry.Username = additionalLogInfo.Username
	}

	var messageToBeUsedInPureStringLog string
	if additionalLogInfo != nil {
		messageToBeUsedInPureStringLog = additionalLogInfo.EnrichedMessage
	} else {
		messageToBeUsedInPureStringLog = message
	}

	pureStringLog := time.Now().Format("2006/01/02 15:04:05") + " - [" + string(level) + "] " + messageToBeUsedInPureStringLog

	l.terminalLogger.Println(pureStringLog)
	l.fileLogger.Println(pureStringLog)
	l.database.Create(&logEntry)
}

func Info(message string) {
	logger.writeLog(models.LogLevelInfo, message, nil)
}

func Warning(message string) {
	logger.writeLog(models.LogLevelWarn, message, nil)
}

func Error(message string) {
	logger.writeLog(models.LogLevelError, message, nil)
}

// verifie si la date a changé et réinitialise le logger de fichier si nécessaire
func (l *Logger) checkDateChange() {
	currentDate := time.Now().Format("2006-01-02")
	if currentDate != l.currentLogDate {
		l.initFileLogger()
	}
}
