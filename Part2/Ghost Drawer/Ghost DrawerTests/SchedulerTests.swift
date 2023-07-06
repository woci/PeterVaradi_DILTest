//
//  SchedulerTests.swift
//  Ghost DrawerTests
//
//  Created by Peter Varadi3 on 2023. 07. 05..
//

import XCTest

final class SchedulerTests: XCTestCase {
    override func setUp() {
        SwinjectContainer.shared.container.register(TestSchedulerDelegate.self) { r in
            let testDelegate = TestSchedulerDelegate(scheduler: r.resolve(SchedulerService.self,
                                                                          name: "MockScheduler")!)
            testDelegate.scheduler.delegate = testDelegate
            return testDelegate
        }

        SwinjectContainer.shared.container.register(SchedulerService.self,
                                                    name: "MockScheduler") { r in
            Scheduler(timer: r.resolve(TimerService.self,
                                       name: "MockTimer")!)
        }

        SwinjectContainer.shared.container.register(TimerService.self,
                                                    name: "MockTimer") { r in
            MockTimer()
        }
    }
    func testSchedule_emptyDrawing() {
        let drawing = Drawing(points: [], pencil: DummyPencil())
        let testDelegate = SwinjectContainer.shared.container.resolve(TestSchedulerDelegate.self)!
        let expectation = XCTestExpectation(description: "Should not be called")
        expectation.isInverted.toggle()
        testDelegate.isDrawingExpectation = expectation

        testDelegate.scheduler.scheduleDrawing(drawing: drawing)

        wait(for: [expectation], timeout: 0.5)
    }

    func testSchedule_onePoint_calledOnce() {
        let drawing = Drawing(points: [Point(position: .zero, timestamp: 0)], pencil: MockPencil())
        let testDelegate = SwinjectContainer.shared.container.resolve(TestSchedulerDelegate.self)!
        let expectation = XCTestExpectation(description: "Should be called ONCE")
        expectation.expectedFulfillmentCount = 1
        testDelegate.isDrawingExpectation = expectation

        testDelegate.scheduler.scheduleDrawing(drawing: drawing)

        wait(for: [expectation], timeout: 0.5)
    }

    func testSchedulFireTimerIntervals_onePoint() {
        let mockPencil = MockPencil()
        let drawing = Drawing(points: [Point(position: .zero, timestamp: 0)], pencil: mockPencil)

        let timerFireIntervalsExpectations = XCTestExpectation(description: "Should be empty")
        let sut = Scheduler(timer: MockFireTimer(asyncFireTimerInterval: { timerInterval in
            if mockPencil.delay == timerInterval {
                timerFireIntervalsExpectations.fulfill()
            }
        }))
        let testDelegate = TestSchedulerDelegate(scheduler: sut)
        testDelegate.scheduler.delegate = testDelegate

        let expectation = XCTestExpectation(description: "Should be called ONCE")
        expectation.expectedFulfillmentCount = 1
        testDelegate.isDrawingExpectation = expectation

        testDelegate.scheduler.scheduleDrawing(drawing: drawing)

        wait(for: [expectation, timerFireIntervalsExpectations], timeout: 0.5)
    }

    func testSchedule_onePoint_correctScheduledPath() {
        let mockPencil = MockPencil()
        let drawing = Drawing(points: [Point(position: .zero, timestamp: 0)], pencil: mockPencil)
        let testDelegate = SwinjectContainer.shared.container.resolve(TestSchedulerDelegate.self)!

        let isDrawingExpectation = XCTestExpectation(description: "Should be called ONCE")
        isDrawingExpectation.expectedFulfillmentCount = 1
        testDelegate.isDrawingExpectation = isDrawingExpectation
        let expectedPathsExpectation = XCTestExpectation(description: "Should be called")
        testDelegate.expectedPathsExpectation = expectedPathsExpectation
        testDelegate.expectedPaths = [ScheduledPath(from: .zero,
                                                    to: .zero,
                                                    color: mockPencil.color,
                                                    renderInterval: 0)]

        testDelegate.scheduler.scheduleDrawing(drawing: drawing)

        wait(for: [isDrawingExpectation, expectedPathsExpectation], timeout: 0.5)
    }

    func testSchedule_threePoints_calledTwice() {
        let drawing = Drawing(points: [Point(position: .zero, timestamp: 0),Point(position: .zero, timestamp: 1),Point(position: .zero, timestamp: 2)], pencil: MockPencil())
        let testDelegate = SwinjectContainer.shared.container.resolve(TestSchedulerDelegate.self)!

        let expectation = XCTestExpectation(description: "Should be called TWICE")
        expectation.expectedFulfillmentCount = 2
        testDelegate.isDrawingExpectation = expectation

        testDelegate.scheduler.scheduleDrawing(drawing: drawing)

        wait(for: [expectation], timeout: 0.5)
    }

    func testSchedulFireTimerIntervals_threePoints() {
        let mockPencil = MockPencil()
        let drawing = Drawing(points: [Point(position: .zero, timestamp: 0),Point(position: .zero, timestamp: 1),Point(position: .zero, timestamp: 2)], pencil: mockPencil)

        var timerFireIntervals = [mockPencil.delay, 1 + mockPencil.delay]
        let timerFireIntervalsExpectations = XCTestExpectation(description: "Should be empty")
        let sut = Scheduler(timer: MockFireTimer(asyncFireTimerInterval: { timerInterval in
            timerFireIntervals.removeAll(where: { $0 == timerInterval })
            if timerFireIntervals.isEmpty {
                timerFireIntervalsExpectations.fulfill()
            }
        }))
        let testDelegate = TestSchedulerDelegate(scheduler: sut)
        testDelegate.scheduler.delegate = testDelegate

        let expectation = XCTestExpectation(description: "Should be called TWICE")
        expectation.expectedFulfillmentCount = 2
        testDelegate.isDrawingExpectation = expectation

        testDelegate.scheduler.scheduleDrawing(drawing: drawing)

        wait(for: [expectation, timerFireIntervalsExpectations], timeout: 0.5)
    }

    func testSchedule_threePoints_correctScheduledPaths() {
        let mockPencil = MockPencil()
        let drawing = Drawing(points: [Point(position: .zero, timestamp: 0),Point(position: CGPoint(x: 1, y: 1), timestamp: 1),Point(position: CGPoint(x: 2, y: 2), timestamp: 3)], pencil: mockPencil)
        let testDelegate = SwinjectContainer.shared.container.resolve(TestSchedulerDelegate.self)!

        let drawingExpectation = XCTestExpectation(description: "Should be called TWICE")
        drawingExpectation.expectedFulfillmentCount = 2
        testDelegate.isDrawingExpectation = drawingExpectation
        let expectedPathsExpectation = XCTestExpectation(description: "Should be called")
        testDelegate.expectedPathsExpectation = expectedPathsExpectation
        testDelegate.expectedPaths = [ScheduledPath(from: .zero,
                                                    to: CGPoint(x: 1, y: 1),
                                                    color: mockPencil.color,
                                                    renderInterval: 1),
                                      ScheduledPath(from: CGPoint(x: 1, y: 1),
                                                    to: CGPoint(x: 2, y: 2),
                                                    color: mockPencil.color,
                                                    renderInterval: 2)]

        testDelegate.scheduler.scheduleDrawing(drawing: drawing)

        wait(for: [drawingExpectation, expectedPathsExpectation], timeout: 0.5)
    }
}

class TestSchedulerDelegate: SchedulerDelegate {
    var scheduler: SchedulerService
    var isDrawingExpectation: XCTestExpectation?
    var expectedPathsExpectation: XCTestExpectation?
    var expectedPaths: [ScheduledPath]?

    init(scheduler: SchedulerService) {
        self.scheduler = scheduler
    }

    func draw(scheduledPath: ScheduledPath) {
        isDrawingExpectation?.fulfill()
        self.expectedPaths?.removeAll(where: { $0 == scheduledPath})
        if let expectedPaths = self.expectedPaths, expectedPaths.isEmpty {
            expectedPathsExpectation?.fulfill()
        }
    }
}

struct DummyPencil: Drawer, Equatable {
    var color: UIColor = .black
    var delay: TimeInterval = 0
}

struct MockPencil: Drawer, Equatable {
    var color: UIColor = .black
    var delay: TimeInterval = 1
}

struct MockFireTimer: TimerService {
    var asyncFireTimerInterval: (TimeInterval) -> Void
    func scheduledTimer(withTimeInterval: TimeInterval, repeats: Bool, block: @escaping (TimerService) -> Void) -> TimerService {
        asyncFireTimerInterval(withTimeInterval)
        block(self)
        return self
    }
}

struct MockTimer: TimerService {
    func scheduledTimer(withTimeInterval: TimeInterval, repeats: Bool, block: @escaping (TimerService) -> Void) -> TimerService {
        block(self)
        return self
    }
}
