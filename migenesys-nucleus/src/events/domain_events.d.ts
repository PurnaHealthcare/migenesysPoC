export interface DomainEvent {
    id: string;
    type: string;
    aggregateId: string;
    userId: string;
    timestamp: number;
    data: any;
}
export interface JourneyStartedEvent extends DomainEvent {
    type: 'JourneyStarted';
    data: {
        title: string;
        startDate: string;
    };
}
//# sourceMappingURL=domain_events.d.ts.map