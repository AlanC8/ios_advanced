from sqlalchemy import Column, Integer, String, Text, DateTime, ForeignKey, Boolean
from sqlalchemy.orm import relationship
from sqlalchemy.sql import func

from app.database import Base

class Habit(Base):
    __tablename__ = "habits"
    
    id = Column(Integer, primary_key=True, index=True)
    title = Column(String, index=True)
    description = Column(Text, nullable=True)
    user_id = Column(Integer, ForeignKey("users.id"))
    created_at = Column(DateTime(timezone=True), server_default=func.now())
    active = Column(Boolean, default=True)
    
    # Relationships
    user = relationship("User", back_populates="habits")
    tracking_entries = relationship("TrackingEntry", back_populates="habit", cascade="all, delete-orphan")
    
    def calculate_streak(self):
        """Calculate the current streak for this habit."""
        from datetime import date, timedelta
        
        # Get ordered tracking entries
        ordered_entries = sorted(
            [entry for entry in self.tracking_entries if entry.completed],
            key=lambda x: x.date,
            reverse=True
        )
        
        if not ordered_entries:
            return 0
        
        # Start with the most recent entry
        streak = 1
        last_date = ordered_entries[0].date
        
        # Check for consecutive days
        for entry in ordered_entries[1:]:
            if last_date - entry.date == timedelta(days=1):
                streak += 1
                last_date = entry.date
            else:
                break
        
        return streak
        
    def calculate_completion_rate(self, days=7):
        """Calculate completion rate for the last X days."""
        from datetime import date, timedelta
        
        today = date.today()
        start_date = today - timedelta(days=days-1)
        
        # Get all entries in the date range
        completed = 0
        total = 0
        
        for i in range(days):
            check_date = start_date + timedelta(days=i)
            entry = next((e for e in self.tracking_entries if e.date == check_date), None)
            
            if entry:
                total += 1
                if entry.completed:
                    completed += 1
            else:
                # Count days without entries as not completed if they're in the past
                if check_date < today:
                    total += 1
        
        return (completed / total * 100) if total > 0 else 0 